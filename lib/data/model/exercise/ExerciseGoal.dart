import 'dart:ffi';

class ExerciseGoal {
  Long id;
  String goal;

  ExerciseGoal({required this.id, required this.goal});

  factory ExerciseGoal.fromJson(Map<String, dynamic> json) {
    return ExerciseGoal(
      id: json['id'],
      goal: json['goal'],
    );
  }
}