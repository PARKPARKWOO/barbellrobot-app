import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:health/config/app_configs.dart';

Future<dynamic> adviceExerciseRequest() async {
  var apiUrl = AppConfigs().apiUrl;
  // TODO: path 입력
  final response = await http.get(Uri.parse('$apiUrl/'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
