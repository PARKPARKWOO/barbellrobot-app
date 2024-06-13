import '../../../config/app_configs.dart';
import '../request/CustomHttpClient.dart';

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

Future<ConsultingModel> requestConsulting(int day, int time) async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/pt'; // Your API endpoint
  var httpClient = CustomHttpClient();

  var body = {"day": day, "time": time};
  var response = await httpClient.post<ConsultingModel>(apiUrl, body: body,
      create: (json) {
        return ConsultingModel.fromJson(json);
      });
  if (response is ApiResponse<ConsultingModel>) {
    return response.data;
  } else {
    throw Exception('Unexpected response type');
  }
}

Future<ConsultingModel> getConsulting() async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/pt'; // Your API endpoint
  var httpClient = CustomHttpClient();

  var response =
  await httpClient.get<ConsultingModel>(apiUrl, create: (json) {
    return ConsultingModel.fromJson(json);
  });
  if (response is ApiResponse<ConsultingModel>) {
    return response.data;
  } else {
    throw Exception('Unexpected response type');
  }
}

Future<bool> hasPt() async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/pt/check';
  var http = CustomHttpClient();

  var response =
  await http.get<HasPtModel>(apiUrl, create: (json) {
    return HasPtModel.fromJson(json);
  });
  if (response is ApiResponse<HasPtModel>)
  {
    return response.data.hasPt;
  } else {
  throw Exception('Unexpected response type');
  }
}

class HasPtModel {
  bool hasPt;

  HasPtModel({required this.hasPt});

  factory HasPtModel.fromJson(Map<String, dynamic> json) {
    return HasPtModel(
        hasPt: json['hasPt']
    );
  }
}