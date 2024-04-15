import 'package:flutter/cupertino.dart';
import 'package:health/config/app_configs.dart';
import 'package:health/data/model/user/sign/JwtTokenModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SignInRequest {
  final String email;
  final String password;

  SignInRequest({required this.email, required this.password});

  // Convert to a Map for JSON encoding (optional)
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

Future<JwtTokenModel?> signIn(String email, String password, String type) async {
  // 환경에 맞게 수정
  final baseUrl = '10.0.2.2';
  final apiUrl = AppConfigs().apiUrl;
  final url = Uri.parse('$apiUrl/sign-in/email/$type');
  final requestBody = SignInRequest(email: email, password: password).toJson(); // Use toJson() if needed

  // status 분기처리
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody), // Encode request body as JSON
  );
  if (response.statusCode == 200) {
    if (jsonDecode(response.body)['success']) {
      var json = jsonDecode(response.body)['data'];
      var result = JwtTokenModel(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', result.accessToken);
      await prefs.setString('refreshToken', result.refreshToken);
      return result;
    }
  }
  return null;
}