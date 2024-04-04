class Exercise {
  int id;
  String name = '';
  double weight = 0;
  int sets = 0;
  int reps = 0;
  DateTime date;

  Exercise({
    required this.id,
    required this.date,
  });

  Exercise.full({
    required this.id,
    required this.name,
    required this.weight,
    required this.sets,
    required this.reps,
    required this.date,
  });
}
