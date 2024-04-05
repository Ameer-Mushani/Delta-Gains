import 'package:delta_gains/workout_provider.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:provider/provider.dart';
import 'weight_selector.dart';
import 'navbar.dart';
import 'exercise.dart';
import 'workout.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EditWorkoutPage(),
    );
  }
}

class EditWorkoutPage extends StatefulWidget {
  const EditWorkoutPage({super.key});

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  String workoutName = '';
  List<Exercise> exercises = [];
  int? expandedExerciseId;
  int lastExerciseId = 0;
  final int _selectedIndex = 1;

  void _onNavigate(String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  void _addExercise() {
    setState(() {
      final newExercise = Exercise(id: ++lastExerciseId, date: DateTime.now());
      exercises.add(newExercise);
      // Set the new exercise as the only expanded item.
      expandedExerciseId = newExercise.id;
      //use unfocus to dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  void initState() {
    super.initState();
    //add a blank exercise on startup
    _addExercise();
  }

  Widget _saveWorkoutButton() {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: TextButton(
        onPressed: () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
          _formKey.currentState?.save();
          Workout newWorkout = Workout(UniqueKey(), workoutName, exercises, DateTime.now());
          Provider.of<WorkoutProvider>(context, listen: false).addWorkout(newWorkout);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 75), // Larger checkmark icon
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text('Workout saved successfully!', textAlign: TextAlign.center), // Centered text
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );

        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: TextStyle(fontSize: 18),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: StadiumBorder(),
          backgroundColor: Colors.blue,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Save',
              style: TextStyle(
                color: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child:  Scaffold(
        appBar: AppBar(
          title: const Text('Create Workout'),
          actions: [
            _saveWorkoutButton(), // Add the Save Workout button here
          ],
        ),
        body: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Workout Name'),
                        onSaved: (value) => workoutName = value ?? '',
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          return ExerciseInput(
                            exercise: exercises[index],
                            isExpanded: expandedExerciseId == exercises[index].id,
                            onExpansionChanged: (isExpanded) {
                              setState(() {
                                if (isExpanded) {
                                  expandedExerciseId = exercises[index].id;
                                } else {
                                  expandedExerciseId =
                                  null; // Collapse if it was expanded and user taps to close
                                }
                              });
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child:  ElevatedButton(
                          onPressed: _addExercise,
                          child: const Text("Add Exercise"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onNavigate,
        ),
      ),
    );

  }
}

class ExerciseInput extends StatefulWidget {
  final Exercise exercise;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;

  const ExerciseInput({super.key,
    required this.exercise,
    this.isExpanded = false,
    required this.onExpansionChanged,
  });

  @override
  _ExerciseInputState createState() => _ExerciseInputState();
}

class _ExerciseInputState extends State<ExerciseInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ExpansionTileCard(
        expandedColor: Theme.of(context).colorScheme.secondaryContainer,
        baseColor: Theme.of(context).colorScheme.secondaryContainer,
        initiallyExpanded: widget.isExpanded,
        onExpansionChanged: widget.onExpansionChanged,
        title: Text(widget.exercise.name.isNotEmpty
            ? widget.exercise.name
            : "New Exercise"),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.exercise.name,
                  decoration: const InputDecoration(labelText: 'Exercise Name', labelStyle: TextStyle(fontSize: 18)),
                  onChanged: (value) => setState(() => widget.exercise.name = value),
                  style: const TextStyle(fontSize: 20),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center row content
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      iconSize: 25.0,
                      onPressed: () => setState(() {
                        widget.exercise.sets = (widget.exercise.sets > 0) ? widget.exercise.sets - 1 : 0;
                      }),
                    ),
                    Text('${widget.exercise.sets} sets', style: const TextStyle(fontSize: 25)), // Display 'X sets'
                    IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 25.0,
                      onPressed: () => setState(() {
                        widget.exercise.sets += 1;
                      }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center row content
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      iconSize: 25.0,
                      onPressed: () => setState(() {
                        widget.exercise.reps = (widget.exercise.reps > 0) ? widget.exercise.reps - 1 : 0;
                      }),
                    ),
                    Text('${widget.exercise.reps} reps', style: const TextStyle(fontSize: 25)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 25.0,
                      onPressed: () => setState(() {
                        widget.exercise.reps += 1;
                      }),
                    ),
                  ],
                ),
                WeightSelector(exercise: widget.exercise),
              ],
            ),
          ),
        ],
      ),
    );
  }
}