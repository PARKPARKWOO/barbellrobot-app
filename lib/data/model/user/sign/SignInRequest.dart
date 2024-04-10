import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInRequest {
  final String email;
  final String password;

  SignInRequest({required this.email, required this.password});

  // Convert to a Map for JSON encoding (optional)
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

Future<http.Response> signIn(String email, String password, String type) async {
  // 환경에 맞게 수정
  final baseUrl = '10.0.2.2';

  final url = Uri.parse('http://$baseUrl:8080/api/v1/sign-in/email/$type');
  final requestBody = SignInRequest(email: email, password: password).toJson(); // Use toJson() if needed

  // status 분기처리
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody), // Encode request body as JSON
  );
  return response;
}