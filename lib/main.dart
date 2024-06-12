import 'package:flutter/material.dart';
import 'package:health/data/model/request/CustomHttpClient.dart';
import 'package:health/screen/main/member/screen_member_main.dart';
import 'package:health/screen/main/member/screen_member_main_page.dart';
import 'package:intl/date_symbol_data_local.dart'; // 수정된 임포트
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health/screen/screen_home.dart';
import 'package:health/screen/sign/screen_sign_in.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 비동기 작업을 시작하기 전에 필요합니다.
  await initializeDateFormatting(); // 날짜 형식 데이터 초기화
  final prefs = await SharedPreferences.getInstance();

  String? accessToken = prefs.getString('accessToken');
  String? type;
  if (accessToken != null) {
    try {
      await CustomHttpClient().refreshToken();
      type = prefs.getString('type');
    }catch (e) {
      accessToken = null;
    }
  }
  runApp(MyApp(
    initialRoute: accessToken == null ? '/signIn' : '/$type/home',
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Health",
      initialRoute: initialRoute,
      routes: {
        '/signIn': (context) => SignInScreen(),
        '/member/home': (context) => MemberMainPageFromFigma(),
      },
      supportedLocales: [
        Locale('en', ''), // 영어
        Locale('ko', ''), // 한국어
      ],
    );
  }
}
