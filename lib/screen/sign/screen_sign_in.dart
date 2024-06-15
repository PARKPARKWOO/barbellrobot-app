// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:health/screen/main/member/screen_member_main.dart';
// import 'package:health/screen/main/member/screen_member_main_page.dart';
// import 'package:health/screen/sign/screen_sign_up_email.dart';
// import 'package:http/http.dart' as http;
// import 'package:health/data/model/user/sign/SignInRequest.dart';
//
// class SignInScreen extends StatefulWidget {
//   @override
//   State<SignInScreen> createState() => _SignInState();
// }
//
// class _SignInState extends State<SignInScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(color: Colors.black12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 20.0), // 텍스트와 버튼 사이 간격
//                 child: Text(
//                   "어떤 기능을 사용하고 싶으신가요?", // 상단에 추가할 텍스트
//                   style: TextStyle(
//                     fontSize: 24, // 텍스트 크기
//                     fontWeight: FontWeight.bold, // 글씨 굵기
//                     color: Colors.black, // 텍스트 색상
//                   ),
//                 ),
//               ),
//               TabGroup(), // TabGroup 추가
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class LoginPage extends StatelessWidget {
//   final String type;
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   LoginPage({Key? key, required this.type}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var userType;
//     if (type == 'member') {
//       userType = "일반회원";
//     } else {
//       userType = "트레이너";
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$userType 로그인'),
//         backgroundColor: Colors.deepPurpleAccent, // 앱 바의 색상을 변경합니다.
//       ),
//       body: SingleChildScrollView(
//         // 키보드가 나타나도 스크롤이 가능하도록 합니다.
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: '이메일',
//                   border: OutlineInputBorder(), // 테두리를 추가합니다.
//                   prefixIcon: Icon(Icons.email), // 아이콘을 추가합니다.
//                 ),
//                 keyboardType: TextInputType.emailAddress, // 키보드 타입을 이메일 주소로 설정합니다.
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   labelText: '비밀번호',
//                   border: OutlineInputBorder(), // 테두리를 추가합니다.
//                   prefixIcon: Icon(Icons.lock), // 아이콘을 추가합니다.
//                 ),
//                 obscureText: true, // 비밀번호를 숨깁니다.
//               ),
//               SizedBox(height: 40),
//               SizedBox(
//                 width: double.infinity, // 버튼의 너비를 최대로 설정합니다.
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     // http request
//                     bool response = await signIn(emailController.text, passwordController.text, type);
//                     print("login = $response");
//                     if (!response) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('로그인에 실패했습니다. 아이디 또는 비밀번호를 확인해주세요'),
//                         ),
//                       );
//                     } else if (type == 'member') {
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(builder: (context) => MemberMainPageFromFigma()),
//                             (Route<dynamic> route) => false,
//                       );
//                     }
//                     // if (type == 'trainer') {
//                     //
//                     // }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurpleAccent, // 버튼 색상을 변경합니다.
//                     padding: EdgeInsets.symmetric(vertical: 15.0), // 버튼 내부 패딩을 조정합니다.
//                   ),
//                   child: Text(
//                     '로그인',
//                     style: TextStyle(fontSize: 18, color: Colors.black),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () {
//                   // 회원가입 페이지로 이동
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SignUpEmail(type: type),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   '계정이 없으신가요? 회원가입',
//                   style: TextStyle(
//                     color: Colors.deepPurple,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class TabGroup extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LoginPage(type: 'member'),
//                   ),
//                 );
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: ShapeDecoration(
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       width: 1,
//                       color: Colors.black.withOpacity(0.1),
//                     ),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: ShapeDecoration(
//                         color: Colors.black.withOpacity(0.05),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           '👥',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 30,
//                             fontFamily: 'Roboto',
//                             fontWeight: FontWeight.w400,
//                             height: 1.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 28,
//                       child: Text(
//                         '일반 회원',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 10,
//                           fontFamily: 'Roboto',
//                           fontWeight: FontWeight.w400,
//                           height: 1.2,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LoginPage(type: 'trainer'),
//                   ),
//                 );
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: ShapeDecoration(
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       width: 1,
//                       color: Colors.black.withOpacity(0.1),
//                     ),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: ShapeDecoration(
//                         color: Colors.black.withOpacity(0.05),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           '🏋️',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 30,
//                             fontFamily: 'Roboto',
//                             fontWeight: FontWeight.w400,
//                             height: 1.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 28,
//                       child: Text(
//                         '트레이너',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 10,
//                           fontFamily: 'Roboto',
//                           fontWeight: FontWeight.w400,
//                           height: 1.2,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/screen/main/member/screen_member_main.dart';
import 'package:health/screen/main/member/screen_member_main_page.dart';
import 'package:health/screen/sign/screen_sign_up_email.dart';
import 'package:http/http.dart' as http;
import 'package:health/data/model/user/sign/SignInRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInState();
}

class _SignInState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: Colors.black12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // 텍스트와 버튼 사이 간격
                child: Text(
                  "어떤 기능을 사용하고 싶으신가요?", // 상단에 추가할 텍스트
                  style: TextStyle(
                    fontSize: 24, // 텍스트 크기
                    fontWeight: FontWeight.bold, // 글씨 굵기
                    color: Colors.black, // 텍스트 색상
                  ),
                ),
              ),
              TabGroup(), // TabGroup 추가
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
    var userType;
    if (type == 'member') {
      userType = "일반회원";
    } else {
      userType = "트레이너";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$userType 로그인'),
        backgroundColor: Colors.deepPurple[50], // 앱 바의 색상을 변경합니다.
      ),
      body: SingleChildScrollView(
        // 키보드가 나타나도 스크롤이 가능하도록 합니다.
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(), // 테두리를 추가합니다.
                  prefixIcon: Icon(Icons.email), // 아이콘을 추가합니다.
                ),
                keyboardType: TextInputType.emailAddress, // 키보드 타입을 이메일 주소로 설정합니다.
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
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          // http request
                          bool response = await signIn(emailController.text, passwordController.text, type);
                          print("login = $response");
                          if (!response) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('로그인에 실패했습니다. 아이디 또는 비밀번호를 확인해주세요'),
                              ),
                            );
                          } else if (type == 'member') {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MemberMainPageFromFigma()),
                                  (Route<dynamic> route) => false,
                            );
                          }
                          // if (type == 'trainer') {
                          //
                          // }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '로그인',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  height: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // 회원가입 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpEmail(type: type),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: ShapeDecoration(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '회원가입',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  height: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // 회원가입 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpEmail(type: type),
                    ),
                  );
                },
                child: Text(
                  '계정이 없으신가요? 회원가입',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(type: 'member'),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: Colors.black.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '👥',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: Text(
                        '일반 회원',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('준비 중 입니다'),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: Colors.black.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '🏋️',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: Text(
                        '트레이너',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
