import 'dart:convert';
import 'package:health/config/app_configs.dart';
import 'package:health/data/model/request/CustomHttpClient.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserHistory {
  final String id;
  final DateTime today;
  final bool attendance;
  final List<String>? breakfastImageUri;
  final List<String>? breakfastFoods;
  final List<String>? lunchImageUri;
  final List<String>? lunchFoods;
  final List<String>? dinnerImageUri;
  final List<String>? dinnerFoods;
  final List<String>? todayImageUri;
  final List<String>? todayVideoUri;

  UserHistory({
    required this.id,
    required this.today,
    required this.attendance,
    this.breakfastImageUri,
    this.breakfastFoods,
    this.lunchImageUri,
    this.lunchFoods,
    this.dinnerImageUri,
    this.dinnerFoods,
    this.todayImageUri,
    this.todayVideoUri,
  });

  factory UserHistory.fromJson(Map<String, dynamic> json) {
    return UserHistory(
      id: json['id'],
      today: DateTime.parse(json['today']),
      attendance: json['attendance'],
      breakfastImageUri: List<String>.from(json['breakfastImageUri'] ?? []),
      breakfastFoods: List<String>.from(json['breakfastFoods'] ?? []),
      lunchImageUri: List<String>.from(json['lunchImageUri'] ?? []),
      lunchFoods: List<String>.from(json['lunchFoods'] ?? []),
      dinnerImageUri: List<String>.from(json['dinnerImageUri'] ?? []),
      dinnerFoods: List<String>.from(json['dinnerFoods'] ?? []),
      todayImageUri: List<String>.from(json['todayImageUri'] ?? []),
      todayVideoUri: List<String>.from(json['todayVideoUri'] ?? []),
    );
  }
}

class TodayHistoryModel {
  final String id;
  final DateTime today;
  final bool attendance;
  final List<String> breakfastImageUri;
  final List<String> breakfastFoods;
  final List<String> lunchImageUri;
  final List<String> lunchFoods;
  final List<String> dinnerImageUri;
  final List<String> dinnerFoods;
  final List<String> todayImageUri;
  final List<String> todayVideoUri;
  final List<ExerciseHistoryResponse> exerciseHistoryResponse;

  TodayHistoryModel({
    required this.id,
    required this.today,
    required this.attendance,
    required this.breakfastImageUri,
    required this.breakfastFoods,
    required this.lunchImageUri,
    required this.lunchFoods,
    required this.dinnerImageUri,
    required this.dinnerFoods,
    required this.todayImageUri,
    required this.todayVideoUri,
    required this.exerciseHistoryResponse,
  });

  factory TodayHistoryModel.fromJson(Map<String, dynamic> json) {
    // 날짜 리스트를 DateTime 객체로 변환
    List<int> todayList = List<int>.from(json['userHistoryResponse']['today']);
    DateTime today = DateTime(todayList[0], todayList[1], todayList[2]);

    return TodayHistoryModel(
      id: json['userHistoryResponse']['id'] as String,
      today: today,
      attendance: json['userHistoryResponse']['attendance'] as bool,
      breakfastImageUri:
          List<String>.from(json['userHistoryResponse']['breakfastImageUri']),
      breakfastFoods:
          List<String>.from(json['userHistoryResponse']['breakfastFoods']),
      lunchImageUri:
          List<String>.from(json['userHistoryResponse']['lunchImageUri']),
      lunchFoods: List<String>.from(json['userHistoryResponse']['lunchFoods']),
      dinnerImageUri:
          List<String>.from(json['userHistoryResponse']['dinnerImageUri']),
      dinnerFoods:
          List<String>.from(json['userHistoryResponse']['dinnerFoods']),
      todayImageUri:
          List<String>.from(json['userHistoryResponse']['todayImageUri']),
      todayVideoUri:
          List<String>.from(json['userHistoryResponse']['todayVideoUri']),
      exerciseHistoryResponse: (json['exerciseHistoryResponse'] as List)
          .map((exercise) => ExerciseHistoryResponse.fromJson(exercise))
          .toList(),
    );
  }
}

class ExerciseHistoryResponse {
  final int id;
  final int itemId;
  final double weight;
  final int exerciseSet;
  final String userHistoryId;
  final DateTime createdAt;

  ExerciseHistoryResponse({
    required this.id,
    required this.itemId,
    required this.weight,
    required this.exerciseSet,
    required this.userHistoryId,
    required this.createdAt,
  });

  factory ExerciseHistoryResponse.fromJson(Map<String, dynamic> json) {
    // 날짜 리스트를 DateTime 객체로 변환
    List<int> createdAtList = List<int>.from(json['createdAt']);
    DateTime createdAt =
        DateTime(createdAtList[0], createdAtList[1], createdAtList[2]);

    return ExerciseHistoryResponse(
      id: json['id'] as int,
      itemId: json['itemId'] as int,
      weight: json['weight'] as double,
      exerciseSet: json['exerciseSet'] as int,
      userHistoryId: json['userHistoryId'] as String,
      createdAt: createdAt,
    );
  }
}

// Future<List<TodayHistoryModel>> historyRequest() async {
//   var baseUrl = AppConfigs().apiUrl;
//   var apiUrl = '$baseUrl/history/month';
//   var http = CustomHttpClient(); // 이 부분은 사용자 정의 HTTP 클라이언트로 가정
//
//   var response = await http.get<ApiResponse<List<TodayHistoryModel>>>(apiUrl, create: (Map<String, dynamic> ) {  });
//
//   if (response.statusCode == 200) {
//     // JSON 응답을 정확하게 파싱
//     Map<String, dynamic> jsonResponse = json.decode(response.body);
//     var userHistoryData = jsonResponse['data'] as List<dynamic>; // 여러 UserHistory 객체를 담고 있는 리스트를 예상
//
//     if (userHistoryData != null) {
//       print(userHistoryData.toString());
//       // UserHistory 데이터 파싱
//       return userHistoryData
//           .map((data) => TodayHistoryModel.fromJson(data as Map<String, dynamic>))
//           .toList();
//     } else {
//       throw Exception('User history data is missing in the response');
//     }
//   } else {
//     throw Exception('Failed to load user history: ${response.statusCode}');
//   }
// }

Future<List<TodayHistoryModel>> historyRequest() async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/history/month';
  var http = CustomHttpClient();

  var response = await http.get<ApiResponse<List<TodayHistoryModel>>>(apiUrl, create: (Map<String, dynamic> json) {
    var list = json['data'] as List;
    return ApiResponse(success: json['success'], data: list.map((item) => TodayHistoryModel.fromJson(item)).toList());
  });

  if (response is ApiResponse<List<TodayHistoryModel>>) {
    return response.data;
  } else if (response is ErrorResponse) {
    // Handle the error response
    print('Error: ${response.message}');
    return [];
  } else {
    throw Exception('Unexpected response type');
  }
}
