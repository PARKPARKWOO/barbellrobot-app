class ConsultingModel {
  String greetingMessage;
  List<Day> days;
  String warn;
  String tip;

  ConsultingModel({
    required this.greetingMessage,
    required this.days,
    required this.warn,
    required this.tip,
  });

  factory ConsultingModel.fromJson(Map<String, dynamic> json) {
    return ConsultingModel(
      greetingMessage: json['greetingMessage'],
      days: (json['days'] as List).map((day) => Day.fromJson(day)).toList(),
      warn: json['warn'],
      tip: json['tip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'greetingMessage': greetingMessage,
      'days': days.map((day) => day.toJson()).toList(),
      'warn': warn,
      'tip': tip,
    };
  }
}

class Day {
  String target;
  List<ConsultingExercise> consultingExercise;

  Day({
    required this.target,
    required this.consultingExercise,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      target: json['target'],
      consultingExercise: (json['consultingExercise'] as List)
          .map((exercise) => ConsultingExercise.fromJson(exercise))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'target': target,
      'consultingExercise':
          consultingExercise.map((exercise) => exercise.toJson()).toList(),
    };
  }
}

class ConsultingExercise {
  int exerciseId;
  int set;
  String? weight;
  int count;
  String advice;

  ConsultingExercise({
    required this.exerciseId,
    required this.set,
    this.weight,
    required this.count,
    required this.advice,
  });

  factory ConsultingExercise.fromJson(Map<String, dynamic> json) {
    return ConsultingExercise(
      exerciseId: json['exerciseId'],
      set: json['set'],
      weight: json['weight'],
      count: json['count'],
      advice: json['advice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'set': set,
      'weight': weight,
      'count': count,
      'advice': advice,
    };
  }
}
