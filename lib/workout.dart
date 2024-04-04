import 'package:flutter/cupertino.dart';

import 'exercise.dart';
class Workout {
  final UniqueKey key;
  String name = '';
  List<Exercise> exercises = [];
  DateTime date;
  //constructor
  Workout(this.key, this.name, this.exercises, this.date);

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }

  void removeExercise(Exercise exercise) {
    exercises.remove(exercise);
  }
}