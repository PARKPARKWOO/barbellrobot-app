import 'dart:convert';
import 'package:health/config/app_configs.dart';
import 'package:health/data/model/request/CustomHttpClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
      breakfastImageUri: List<String>.from(json['userHistoryResponse']['breakfastImageUri'] ?? []),
      breakfastFoods: List<String>.from(json['userHistoryResponse']['breakfastFoods'] ?? []),
      lunchImageUri: List<String>.from(json['userHistoryResponse']['lunchImageUri'] ?? []),
      lunchFoods: List<String>.from(json['userHistoryResponse']['lunchFoods'] ?? []),
      dinnerImageUri: List<String>.from(json['userHistoryResponse']['dinnerImageUri'] ?? []),
      dinnerFoods: List<String>.from(json['userHistoryResponse']['dinnerFoods'] ?? []),
      todayImageUri: List<String>.from(json['userHistoryResponse']['todayImageUri'] ?? []),
      todayVideoUri: List<String>.from(json['userHistoryResponse']['todayVideoUri'] ?? []),
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
  final int? count; // 추가된 필드

  ExerciseHistoryResponse({
    required this.id,
    required this.itemId,
    required this.weight,
    required this.exerciseSet,
    required this.userHistoryId,
    required this.createdAt,
    this.count, // 추가된 필드
  });

  factory ExerciseHistoryResponse.fromJson(Map<String, dynamic> json) {
    // 날짜 리스트를 DateTime 객체로 변환
    List<int> createdAtList = List<int>.from(json['createdAt']);
    DateTime createdAt = DateTime(createdAtList[0], createdAtList[1], createdAtList[2]);

    return ExerciseHistoryResponse(
      id: json['id'] as int,
      itemId: json['itemId'] as int,
      weight: json['weight'] as double,
      exerciseSet: json['exerciseSet'] as int,
      userHistoryId: json['userHistoryId'] as String,
      createdAt: createdAt,
      count: json['count'] as int?, // 추가된 필드
    );
  }
}

Future<List<TodayHistoryModel>> historyRequest() async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/history/month';
  var http = CustomHttpClient();

  var response = await http.get<List<TodayHistoryModel>>(apiUrl, create: (json) {
    var list = json as List<dynamic>;
    return list.map((item) => TodayHistoryModel.fromJson(item)).toList();
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
