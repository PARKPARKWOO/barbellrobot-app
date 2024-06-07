import 'dart:ffi';

import 'package:health/data/model/exercise/ExerciseArea.dart';
import 'package:health/data/model/exercise/ExerciseGoal.dart';

import '../../../config/app_configs.dart';
import '../request/CustomHttpClient.dart';

class ExerciseItem {
  Long id;
  String exerciseName;
  String? videoUrl;
  String? imageUrl;

  ExerciseItem({
    required this.id,
    required this.exerciseName,
    this.videoUrl,
    this.imageUrl,
  });
}

class ExerciseItemDetail {
  Long id;
  String exerciseName;
  String? videoUri;
  String? imageUrl;
  List<ExerciseArea> exerciseAreas;
  List<ExerciseGoal> exerciseGoals;
  int count;

  ExerciseItemDetail({
    required this.id,
    required this.exerciseName,
    this.videoUri,
    this.imageUrl,
    required this.exerciseAreas,
    required this.exerciseGoals,
    required this.count,
  });

  factory ExerciseItemDetail.fromJson(Map<String, dynamic> json) {
    return ExerciseItemDetail(
      id: json['id'],
      exerciseName: json['exerciseName'],
      videoUri: json['videoUri'],
      imageUrl: json['imageUri'],
      exerciseAreas: (json['exerciseAreas'] as List)
          .map((area) => ExerciseArea.fromJson(area))
          .toList(),
      exerciseGoals: (json['exerciseGoals'] as List)
          .map((goal) => ExerciseGoal.fromJson(goal))
          .toList(),
      count: json['count'],
    );
  }
}

Future<List<ExerciseItemDetail>> findAllItemDetail() async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/items';
  var http = CustomHttpClient();

  var response = await http.get<List<ExerciseItemDetail>>(apiUrl,
      create: (json) {
    var list = json['data'] as List;
    return list.map((item) => ExerciseItemDetail.fromJson(item)).toList();
  });

  if (response is ApiResponse<List<ExerciseItemDetail>>) {
    return response.data;
  } else if (response is ErrorResponse) {
    // Handle the error response
    print('Error: ${response.message}');
    return [];
  } else {
    throw Exception('Unexpected response type');
  }
}
