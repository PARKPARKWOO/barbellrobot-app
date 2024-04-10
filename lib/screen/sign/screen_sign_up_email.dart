import 'package:flutter/material.dart';
import 'package:health/data/model/user/sign/SignUpDetails.dart';
import 'package:health/screen/sign/screen_sign_up_member_detail.dart';
import 'package:health/screen/sign/screen_sign_up_trainer_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../data/model/user/sign/SendEmailVerifyRequest.dart';

class SignUpEmail extends StatefulWidget {
  final String type;

  const SignUpEmail({super.key, required this.type});

  @override
  _SignUpEmailState createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final authNumberController = TextEditingController();
  String _email = '';
  int? _authenticationNumber;
  String _gender = 'MALE';
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nicknameController = TextEditingController();
  String _nickname = '';
  bool _isNicknameValid = false;

  // url
  var baseUrl = '10.0.2.2';

  Future<void> verifyNickname(String nickname) async {
    var url = Uri.parse(
        'http://$baseUrl:8080/api/v1/sign-up/verify/nickname/$nickname');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
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
                // TextFormField(
                //   controller: emailController,
                //   decoration: InputDecoration(labelText: '이메일'),
                // ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: '이메일',
                        ),
                        keyboardType: TextInputType
                            .emailAddress, // 키보드 타입을 이메일 주소로 설정합니다.
                      ),
                    ),
                    SizedBox(width: 10), // 필드와 버튼 사이의 간격을 추가합니다.
                    IconButton(
                      icon: Icon(Icons.email_outlined), // 메일 아이콘 사용
                      onPressed: () async {
                        // 이메일 인증 로직을 여기에 구현합니다.
                        var email = emailController.text;
                        if (email.isNotEmpty) {
                          // 이메일 인증 요청 로직
                          var response = await sendEmailVerifyRequest(email);
                          if (response) {
                            // 성공적으로 이메일 인증 요청이 처리되었을 때
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('인증 메일이 발송되었습니다. 메일을 확인해주세요.')),
                            );
                          } else {
                            // 이메일 인증 요청 처리 실패
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  '인증 메일 발송에 실패했습니다. 이메일 주소를 확인해주세요.')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('이메일 주소를 입력해주세요.')),
                          );
                        }
                      },
                      color: Theme
                          .of(context)
                          .primaryColor, // 아이콘 색상 설정
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: authNumberController,
                        decoration: InputDecoration(labelText: '인증번호 입력'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 인증 확인 로직
                      },
                      child: Text('인증 확인'),
                    ),
                  ],
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: '비밀번호'),
                  obscureText: true,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(labelText: '비밀번호 확인'),
                  obscureText: true,
                  validator: (value) {
                    if (value != passwordController.text) {
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nicknameController,
                        decoration: InputDecoration(labelText: '닉네임'),
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _isNicknameValid) {
                      if (widget.type == 'member') {
                        SignUpMemberDetails signUpDetails = SignUpMemberDetails(
                          email: emailController.text,
                          password: passwordController.text,
                          nickname: nicknameController.text,
                          gender: _gender, // 'MALE' 또는 'FEMALE'
                          // 다른 필드들은 SignUpPageTwo에서 입력받음
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignUpMemberPageTwo(
                                    signUpDetails: signUpDetails),
                          ),
                        );
                      } else if (widget.type == 'trainer') {
                        SignUpTrainerDetails signUpDetails = SignUpTrainerDetails(
                            email: emailController.text,
                            password: passwordController.text,
                            nickname: nicknameController.text,
                            gender: _gender
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignUpTrainerPageTwo(
                                    signUpDetails: signUpDetails),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('다음'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
