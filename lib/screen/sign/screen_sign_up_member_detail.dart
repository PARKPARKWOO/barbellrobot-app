import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health/config/app_configs.dart';
import 'package:health/data/model/user/sign/SignInRequest.dart';
import 'package:health/data/model/user/sign/SignUpDetails.dart';
import 'package:health/screen/main/member/screen_member_main.dart';
import 'package:health/screen/main/member/screen_member_main_page.dart';
import 'package:health/screen/sign/screen_sign_in.dart';
import 'package:http/http.dart' as http;
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
  final nicknameController = TextEditingController();
  String _gender = 'MALE';
  bool _isNicknameValid = false;
  String _nickname = '';

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    skeletalMuscleMassController.dispose();
    exerciseMonthsController.dispose();
    super.dispose();
  }

  Future<void> verifyNickname(String nickname) async {
    var baseUrl = AppConfigs().apiUrl;
    var url = Uri.parse('$baseUrl/sign-up/verify/nickname/$nickname');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body)['data'];
      setState(() {
        _isNicknameValid = responseJson['canNickname'];
      });
      if (!_isNicknameValid) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('닉네임이 이미 사용 중입니다.')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('사용 가능한 닉네임입니다.')));
        _nickname = nickname;
      }
    } else {
      // 오류 처리
      print('닉네임 검증 실패');
    }
  }

  bool _isFormValid() {
    return nicknameController.text.isNotEmpty &&
        _isNicknameValid &&
        ageController.text.isNotEmpty &&
        heightController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        exerciseMonthsController.text.isNotEmpty;
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nicknameController,
                        decoration: InputDecoration(labelText: '닉네임'),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        verifyNickname(nicknameController.text);
                      },
                      child: Text('중복 확인'),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(labelText: '성별'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                  items: <String>['MALE', 'FEMALE']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value == 'MALE' ? '남자' : '여자'),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: '나이'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                TextFormField(
                  controller: heightController,
                  decoration: InputDecoration(labelText: '키 (cm)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: '몸무게 (kg)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
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
                  onChanged: (value) {
                    setState(() {});
                  },
                ),

                ElevatedButton(
                  onPressed: _isFormValid()
                      ? () async {
                    if (widget.signUpDetails.type == 'email') {
                      await signUp(
                        email: widget.signUpDetails.email,
                        nickname: _nickname,
                        password: widget.signUpDetails.password,
                        gender: _gender,
                        age: int.tryParse(ageController.text),
                        exerciseMonths:
                        int.tryParse(exerciseMonthsController.text),
                        tall: double.tryParse(heightController.text),
                        weight: double.tryParse(weightController.text),
                        skeletalMuscleMass: double.tryParse(
                            skeletalMuscleMassController.text),
                        authenticationString:
                        widget.signUpDetails.authenticationString,
                        type: 'member', // 또는 'trainer', 상황에 따라 결정
                      ).then((_) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                              (Route<dynamic> route) => false,
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('회원가입 실패: $error')),
                        );
                      });
                    } else if (widget.signUpDetails.type == 'social') {
                      var success = await signInSocial(
                        age : int.tryParse(ageController.text)!,
                        exerciseMonths: int.tryParse(exerciseMonthsController.text)!,
                        tall : double.tryParse(heightController.text)!,
                        weight: double.tryParse(weightController.text)!,
                        skeletalMuscleMass: double.tryParse(
                            skeletalMuscleMassController.text),
                        gender: _gender,
                        nickname: _nickname,
                      );
                      if (success) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MemberMainPageFromFigma()),
                              (Route<dynamic> route) => false,
                        );
                      }
                    }
                  }
                      : null,
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
