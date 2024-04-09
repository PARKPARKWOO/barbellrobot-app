import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInRequest {
  final String email;
  final String password;

  SignInRequest({required this.email, required this.password});

  // Convert to a Map for JSON encoding (optional)
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

Future<http.Response> signIn(String email, String password) async {
  final url = Uri.parse('http://your_server_address/api/v1/email/member');
  final requestBody = SignInRequest(email: email, password: password).toJson(); // Use toJson() if needed

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody), // Encode request body as JSON
  );
  return response;
}