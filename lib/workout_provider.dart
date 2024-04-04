import 'package:flutter/material.dart';
import 'workout.dart';
import 'exercise.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
class WorkoutProvider extends ChangeNotifier {
  final List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }

  Future<void> loadWorkouts() async {
    final String response = await rootBundle.loadString('assets/workouts.json');
    final data = await json.decode(response);
    for (var workoutData in data['workouts']) {
      final workout = Workout(
        workoutData['name'],
        (workoutData['exercises'] as List).map((e) => Exercise.full(
          id: e['id'],
          name: e['name'],
          weight: e['weight'],
          sets: e['sets'],
          reps: e['reps'],
          date: DateTime.parse(e['date']),
        )).toList(),
        DateTime.parse(workoutData['date']),
      );
      _workouts.add(workout);
    }
    notifyListeners();
  }
}