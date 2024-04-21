import 'dart:convert';
import 'package:health/config/app_configs.dart';
import 'package:http/http.dart' as http;

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
}

Future<List<UserHistory>> historyRequest() async {
  // 예제 URL, 실제 URL로 교체 필요
  var apiUrl = AppConfigs().apiUrl;
  final response = await http.get(Uri.parse('https://$apiUrl/user/history'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => UserHistory(id: id, today: today, attendance: attendance).fromJson(data)).toList();
  } else {
    throw Exception('Failed to load user history');
  }
}
