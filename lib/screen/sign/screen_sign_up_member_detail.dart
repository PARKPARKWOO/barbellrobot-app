import 'package:flutter/material.dart';
import 'package:health/data/model/user/sign/SignUpDetails.dart';
import 'package:health/screen/main/screen_member_main.dart';

import '../../data/model/user/sign/SignUpRequest.dart';

class SignUpMemberPageTwo extends StatefulWidget {
  final SignUpMemberDetails signUpDetails;

  SignUpMemberPageTwo({Key? key, required this.signUpDetails})
      : super(key: key);

  @override
  _SignUpMemberPageTwoState createState() => _SignUpMemberPageTwoState();
}

class _SignUpMemberPageTwoState extends State<SignUpMemberPageTwo> {
  final _formKey = GlobalKey<FormState>();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final skeletalMuscleMassController = TextEditingController();
  final exerciseMonthsController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    skeletalMuscleMassController.dispose();
    exerciseMonthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 - 추가 정보'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: '나이'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: heightController,
                  decoration: InputDecoration(labelText: '키 (cm)'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: '몸무게 (kg)'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: skeletalMuscleMassController,
                  decoration: InputDecoration(labelText: '골격근량 (kg) - 선택 사항'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: exerciseMonthsController,
                  decoration: InputDecoration(labelText: '운동 개월 수'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // 회원가입 로직을 처리합니다.
                    await signUp(
                      email: widget.signUpDetails.email,
                      nickname: widget.signUpDetails.nickname,
                      password: widget.signUpDetails.password,
                      gender: widget.signUpDetails.gender,
                      age: int.tryParse(ageController.text),
                      exerciseMonths:
                          int.tryParse(exerciseMonthsController.text),
                      tall: double.tryParse(heightController.text),
                      weight: double.tryParse(weightController.text),
                      skeletalMuscleMass:
                          double.tryParse(skeletalMuscleMassController.text),
                      authenticationString:
                          widget.signUpDetails.authenticationString,
                      type: 'member', // 또는 'trainer', 상황에 따라 결정
                    ).then((_) {
                      // 회원가입 성공 후 로그인 화면으로 이동
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MemberMainPage()),
                        (Route<dynamic> route) => false,
                      );
                    }).catchError((error) {
                      // 오류 처리
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('회원가입 실패: $error')),
                      );
                    });
                  },
                  child: Text('회원가입 완료'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
