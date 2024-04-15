import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/screen/sign/screen_sign_up_email.dart';
import 'package:http/http.dart' as http;
import 'package:health/data/model/user/sign/SignInRequest.dart';
import 'package:health/data/model/user/sign/SignUpRequest.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInState();
}

class _SignInState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // 중앙 정렬을 위해 Center 위젯을 사용합니다.
        child: Padding( // 전체적인 패딩을 제공합니다.
          padding: const EdgeInsets.all(20.0),
          child: Row( // Row 위젯을 사용하여 버튼들을 가로로 배치합니다.
            mainAxisAlignment: MainAxisAlignment.center, // 버튼들을 가로축 중앙에 배치합니다.
            children: [
              Expanded( // Expanded 위젯을 사용하여 버튼이 가용 공간을 균등하게 차지하도록 합니다.
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(type: 'member'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 버튼 배경색을 설정합니다.
                    padding: EdgeInsets.symmetric(vertical: 15.0), // 버튼 내부 패딩을 설정합니다.
                    textStyle: TextStyle(fontSize: 18), // 텍스트 스타일을 설정합니다.
                  ),
                  child: Text('일반 회원'),
                ),
              ),
              SizedBox(width: 20), // 버튼 사이의 간격을 설정합니다.
              Expanded( // Expanded 위젯을 사용하여 버튼이 가용 공간을 균등하게 차지하도록 합니다.
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(type: 'trainer'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 버튼 배경색을 변경합니다.
                    padding: EdgeInsets.symmetric(vertical: 15.0), // 버튼 내부 패딩을 설정합니다.
                    textStyle: TextStyle(fontSize: 18), // 텍스트 스타일을 설정합니다.
                  ),
                  child: Text('트레이너'),
                ),
              ),
            ],
          ),
        ),
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
        title: Text('$type Login'),
        backgroundColor: Colors.deepPurple, // 앱 바의 색상을 변경합니다.
      ),
      body: SingleChildScrollView( // 키보드가 나타나도 스크롤이 가능하도록 합니다.
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40), // 상단 여백 추가
              Text(
                '환영합니다!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(), // 테두리를 추가합니다.
                  prefixIcon: Icon(Icons.email), // 아이콘을 추가합니다.
                ),
                keyboardType: TextInputType
                    .emailAddress, // 키보드 타입을 이메일 주소로 설정합니다.
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(), // 테두리를 추가합니다.
                  prefixIcon: Icon(Icons.lock), // 아이콘을 추가합니다.
                ),
                obscureText: true, // 비밀번호를 숨깁니다.
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity, // 버튼의 너비를 최대로 설정합니다.
                child: ElevatedButton(
                  onPressed: () async {
                    // http request
                    var response = signIn(emailController.text, passwordController.text, type);
                    if (response == null) {
                      // TODO: Login 실패처리 해야함
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // 버튼 색상을 변경합니다.
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0), // 버튼 내부 패딩을 조정합니다.
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // 회원가입 페이지로 이동
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpEmail(type: type,)));
                },
                child: Text(
                  '계정이 없으신가요? 회원가입',
                  style: TextStyle(color: Colors.deepPurple,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}