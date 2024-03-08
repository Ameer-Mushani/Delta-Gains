import 'exercise.dart';
class Workout {
  String name = '';
  List<Exercise> exercises = [];
  //constructor
  Workout(this.name, this.exercises);

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }

  void removeExercise(Exercise exercise) {
    exercises.remove(exercise);
  }
}