import 'dart:convert';
import 'package:health/config/app_configs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyAuthNumberRequest {
  String email;
  int authNumber;

  VerifyAuthNumberRequest({
    required this.email,
    required this.authNumber,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'authenticationNumber': authNumber};
  }
}

Future<bool> verifyEmail(String email, int authNumber) async {
  final apiUrl = AppConfigs().apiUrl;
  final url = Uri.parse('$apiUrl/sign-up/verify');

  final requestBody = VerifyAuthNumberRequest(email: email, authNumber: authNumber).toJson();
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    if (responseData['success']) {
      String authString = responseData['data']['authenticationString'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authenticationString', authString);
      return true;
    }
  }
  return false;
}
