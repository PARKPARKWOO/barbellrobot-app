import 'dart:ffi';

import 'package:health/data/model/exercise/ExerciseArea.dart';
import 'package:health/data/model/exercise/ExerciseGoal.dart';

import '../../../config/app_configs.dart';
import '../request/CustomHttpClient.dart';

class ExerciseItem {
  int id;
  String exerciseName;
  List<String> videoUrl;
  List<String> imageUrl;

  ExerciseItem({
    required this.id,
    required this.exerciseName,
    required this.videoUrl,
    required this.imageUrl,
  });

  factory ExerciseItem.fromJson(Map<String, dynamic> json) {
    return ExerciseItem(
      id: json['id'],
      exerciseName: json['exerciseName'],
      videoUrl: List<String>.from(json['videoUrl'] ?? []),
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
    );
  }
}

class ExerciseItemDetail {
  int id;
  String exerciseName;
  List<String> videoUri;
  List<String> imageUrl;
  List<ExerciseArea> exerciseAreas;
  List<ExerciseGoal> exerciseGoals;
  int count;

  ExerciseItemDetail({
    required this.id,
    required this.exerciseName,
    required this.videoUri,
    required this.imageUrl,
    required this.exerciseAreas,
    required this.exerciseGoals,
    required this.count,
  });

  factory ExerciseItemDetail.fromJson(Map<String, dynamic> json) {
    return ExerciseItemDetail(
      id: json['id'],
      exerciseName: json['exerciseName'],
      videoUri: List<String>.from(json['videoUri'] ?? []),
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      exerciseAreas: (json['exerciseAreas'] as List?)
              ?.map((area) => ExerciseArea.fromJson(area))
              .toList() ??
          [],
      exerciseGoals: (json['exerciseGoals'] as List?)
              ?.map((goal) => ExerciseGoal.fromJson(goal))
              .toList() ??
          [],
      count: json['count'] ?? 0,
    );
  }
}

Future<List<ExerciseItemDetail>> findAllItemDetail(List<int>? ids) async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/items';

  // Check if ids is not null and not empty
  if (ids != null && ids.isNotEmpty) {
    // Convert ids to a comma-separated string
    String idsParam = ids.join(',');
    // Append the ids parameter to the apiUrl
    apiUrl = '$apiUrl?itemIds=$idsParam';
  }

  var http = CustomHttpClient();

  var response =
  await http.get<List<ExerciseItemDetail>>(apiUrl, create: (json) {
    var list = json as List<dynamic>;
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
