import 'dart:ffi';

import '../../../config/app_configs.dart';
import '../request/CustomHttpClient.dart';

class CompleteExercise {
  String userHistoryId;
  List<CompleteExerciseItem> items;

  CompleteExercise({
    required this.userHistoryId,
    required this.items,
  });
}

class CompleteExerciseItem {
  int itemId;
  Double? weight;
  int exerciseSet;

  CompleteExerciseItem({
    required this.itemId,
    this.weight,
    required this.exerciseSet,
  });
}

Future<void> completeExercise() async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/history/month';
  var http = CustomHttpClient();

  var response =
      await http.post<void>(apiUrl, create: (json) {});

  if (response is ApiResponse<void>) {
    return response.data;
  } else if (response is ErrorResponse) {
    // Handle the error response
    print('Error: ${response.message}');
  } else {
    throw Exception('Unexpected response type');
  }
}
