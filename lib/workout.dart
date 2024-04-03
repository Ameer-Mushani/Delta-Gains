import 'exercise.dart';
class Workout {
  String name = '';
  List<Exercise> exercises = [];
  DateTime date;
  //constructor
  Workout(this.name, this.exercises, this.date);

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }

  void removeExercise(Exercise exercise) {
    exercises.remove(exercise);
  }
}