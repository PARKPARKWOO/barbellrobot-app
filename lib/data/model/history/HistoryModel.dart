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
      id: json['id'] as String,
      today: DateTime.parse(json['today']),
      attendance: json['attendance'] as bool,
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

Future<List<UserHistory>> historyRequest() async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/history/month';
  var http = CustomHttpClient();

  var response = await http.get(apiUrl);

  if (response.statusCode == 200) {
    // Parsing the nested JSON response correctly
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    var userHistoryData = jsonResponse['data']['userHistoryResponse']; // Access the nested path
    if (userHistoryData != null) {
      // Parsing the user history data
      return [UserHistory.fromJson(userHistoryData)]; // Wrap the single object in a list if necessary
    } else {
      throw Exception('User history data is missing in the response');
    }
  } else {
    throw Exception('Failed to load user history: ${response.statusCode}');
  }
}
