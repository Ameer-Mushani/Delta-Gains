import 'package:delta_gains/workout_provider.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:provider/provider.dart';
import 'weight_selector.dart';
import 'dart:ui';
import 'navbar.dart';
import 'main.dart';
import 'exercise.dart';
import 'workout.dart';
import 'create_workout.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditWorkoutPage(),
    );
  }
}

class EditWorkoutPage extends StatefulWidget {
  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  String workoutName = '';
  List<Exercise> exercises = [];
  int? expandedExerciseId;
  int lastExerciseId = 0;
  int _selectedIndex = 1;

  void _onNavigate(String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  void _addExercise() {
    setState(() {
      final newExercise = Exercise(id: ++lastExerciseId);
      exercises.add(newExercise);
      // Set the new exercise as the only expanded item.
      expandedExerciseId = newExercise.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Workout')),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                  ElevatedButton(
                    onPressed: _addExercise,
                    child: Icon(Icons.add),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/createWorkout'));
                      _formKey.currentState?.save();
                      // Handle the saved workout and exercises here
                      Workout newWorkout =  Workout(workoutName, exercises);
                      workoutProvider.addWorkout(newWorkout);

                    },
                    child: Text('Save Workout'),

                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigate,
      ),
    );
  }
}

class ExerciseInput extends StatefulWidget {
  final Exercise exercise;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;

  ExerciseInput({
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                  decoration: InputDecoration(labelText: 'Exercise Name', labelStyle: TextStyle(fontSize: 18)),
                  onChanged: (value) => setState(() => widget.exercise.name = value),
                  style: TextStyle(fontSize: 20),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center row content
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      iconSize: 25.0,
                      onPressed: () => setState(() {
                        widget.exercise.sets = (widget.exercise.sets > 0) ? widget.exercise.sets - 1 : 0;
                      }),
                    ),
                    Text('${widget.exercise.sets} sets', style: TextStyle(fontSize: 25)), // Display 'X sets'
                    IconButton(
                      icon: Icon(Icons.add),
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
                      icon: Icon(Icons.remove),
                      iconSize: 25.0,
                      onPressed: () => setState(() {
                        widget.exercise.reps = (widget.exercise.reps > 0) ? widget.exercise.reps - 1 : 0;
                      }),
                    ),
                    Text('${widget.exercise.reps} reps', style: TextStyle(fontSize: 25)),
                    IconButton(
                      icon: Icon(Icons.add),
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

