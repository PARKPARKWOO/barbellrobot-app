import 'dart:ffi';

class ExerciseArea {
  int id;
  String area;

  ExerciseArea({required this.id, required this.area});

  factory ExerciseArea.fromJson(Map<String, dynamic> json) {
    return ExerciseArea(
      id: json['id'],
      area: json['area'],
    );
  }
}