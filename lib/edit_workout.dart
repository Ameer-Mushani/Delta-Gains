import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'dart:ui';
import 'navbar.dart';
import 'main.dart';

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
      appBar: AppBar(title: Text('Edit Workout')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Workout Name'),
                onSaved: (value) => workoutName = value ?? '',
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                  _formKey.currentState?.save();
                  // Handle the saved workout and exercises here
                },
                child: Text('Save Workout'),
              ),
            ],
          ),
        ),
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
                  decoration: InputDecoration(labelText: 'Exercise Name'),
                  onChanged: (value) =>
                      setState(() => widget.exercise.name = value),
                ),
                TextFormField(
                  initialValue: widget.exercise.weight.toString(),
                  decoration: InputDecoration(labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(
                      () => widget.exercise.weight = int.tryParse(value) ?? 0),
                ),
                TextFormField(
                  initialValue: widget.exercise.sets.toString(),
                  decoration: InputDecoration(labelText: 'Sets'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(
                      () => widget.exercise.sets = int.tryParse(value) ?? 0),
                ),
                TextFormField(
                  initialValue: widget.exercise.reps.toString(),
                  decoration: InputDecoration(labelText: 'Reps'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(
                      () => widget.exercise.reps = int.tryParse(value) ?? 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Exercise {
  int id;
  String name = '';
  int weight = 0;
  int sets = 0;
  int reps = 0;

  Exercise({required this.id});
}
