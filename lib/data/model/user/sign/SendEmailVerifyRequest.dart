import 'dart:convert';

import 'package:http/http.dart' as http;

class SendEmailVerifyRequest {
  String email;
  SendEmailVerifyRequest({required this.email});

}

Future<bool> sendEmailVerifyRequest(String email) async {
  var baseUrl = '10.0.2.2';
  var url = Uri.parse('http://$baseUrl:8080/api/v1/sign-up/send/email-verify');
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email}),
  );

  if (response.statusCode == 200) {
    // 서버로부터 성공적인 응답을 받았을 때의 처리
    return jsonDecode(response.body)['success'];
  } else {
    // 오류 처리
    print('이메일 인증 요청 실패');
    return false;
  }
}

Future<void> verifyAuthenticationNumber(String email, int authenticationNumber) async {
  var baseUrl = '10.0.2.2';
  var url = Uri.parse('http://$baseUrl:8080/api/sign-up/verify');
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'authenticationNumber': authenticationNumber,
    }),
  );

  if (response.statusCode == 200) {
    // 인증번호 검증 성공
    print('인증번호 검증 성공');
  } else {
    // 인증번호 검증 실패
    print('인증번호 검증 실패');
  }
}