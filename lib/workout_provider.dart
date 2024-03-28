import 'package:flutter/material.dart';
import 'workout.dart';
class WorkoutProvider extends ChangeNotifier {
  final List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }
}