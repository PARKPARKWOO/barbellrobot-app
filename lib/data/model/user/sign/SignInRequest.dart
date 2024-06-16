import 'package:flutter/cupertino.dart';
import 'package:health/config/app_configs.dart';
import 'package:health/data/model/request/CustomHttpClient.dart';
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

Future<bool> signIn(String email, String password, String type) async {
  try {
    final apiUrl = AppConfigs().apiUrl;
    final url = Uri.parse('$apiUrl/sign-in/email/$type');
    final requestBody = SignInRequest(email: email, password: password)
        .toJson(); // Use toJson() if needed

    // status 분기처리
    Map<String, String> header = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      url,
      headers: header,
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
        await prefs.setString('type', type);
        return true;
      }
    }
  } catch (e) {
    print(e.toString());
    return false;
  }
  return false;
}

Future<bool> signInSocial(
    {required int age,
    required int exerciseMonths,
    required double tall,
    required double weight,
    double? skeletalMuscleMass,
    required String gender,
    required String nickname}) async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/member'; // Your API endpoint
  var httpClient = CustomHttpClient();

  var body = {
    "age": age,
    "exerciseMonths": exerciseMonths,
    "tall": tall,
    "weight": weight,
    "skeletalMuscleMass": skeletalMuscleMass,
    "gender": gender,
    "nickname": nickname
  };
  var response =
      await httpClient.post<void>(apiUrl, body: body, create: (json) {
    return;
  });
  if (response is ApiResponse<void>) {
    return response.success;
  } else {
    throw Exception('Unexpected response type');
  }
}
