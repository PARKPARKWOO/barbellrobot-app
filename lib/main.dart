import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:health/config/app_configs.dart';
import 'package:health/screen/screen_home.dart';
import 'package:health/screen/sign/screen_sign_in.dart';
import 'package:http/http.dart' as http;
import 'data/model/user/sign/SignInRequest.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Health",
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(type: 'member'),
                ),
              );
            },
            child: Text('일반 회원'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(type: 'trainer'),
                ),
              );
            },
            child: Text('트레이너'),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final String type;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Center(
        child: Column(
          children: [
            // 로그인 양식
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '아이디',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;

                // 로그인 API 요청 URL
                var url = Uri.parse('http://10.0.2.2:8080/api/v1/sign-in/email/$type');
                print("type is = $type, email is = $email");

                // HTTP 요청 본문에 이메일과 비밀번호를 JSON 형식으로 포함
                var response = await http.post(
                  url,
                  body: jsonEncode({
                    'email': email,
                    'password': password,
                  }),
                  headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                );
                print(response.body);

                // 로그인 결과 처리
                // 여기서는 예시로 상태 코드에 따라 다른 액션을 취하는 코드를 주석 처리해 두었습니다.
              },
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
