import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:health/config/app_configs.dart';
import 'package:health/data/model/user/member/Member.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class KakaoLogin {
  // signInWithKakao() async {
  //   final UserApi api = UserApi.instance;
  //   if (await isKakaoTalkInstalled()) {
  //     try {
  //       api.loginWithKakaoTalk().then((token) {
  //         print("access Token ${token.accessToken}");
  //         return api.me();
  //       });
  //     } catch (error) {
  //       print('카카오톡으로 로그인 실패 $error');
  //
  //       // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
  //       // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
  //       if (error is PlatformException && error.code == 'CANCELED') {
  //         return;
  //       }
  //       // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
  //       try {
  //         var token = await UserApi.instance.loginWithKakaoAccount();
  //         print("access Token ${token.accessToken}");
  //         return api.me();
  //       } catch (error) {
  //         print('카카오계정으로 로그인 실패 $error');
  //       }
  //     }
  //   } else {
  //     try {
  //       var token = await UserApi.instance.loginWithKakaoAccount();
  //       print("this else access Token ${token.accessToken}");
  //       return api.me();
  //     } catch (error) {
  //       print('카카오계정으로 로그인 실패 $error');
  //     }
  //   }
  // }
  Future<Member> signInWithKakao(String type) async {
    OAuthToken token;
    final prefs = await SharedPreferences.getInstance();
    if (await isKakaoTalkInstalled()) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
      } catch (e) {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
    }

    var apiUrl = AppConfigs().apiUrl;

    // Use user information (user.id, user.kakaoAccount.email, etc.)
    // and send it to your backend server
    final response = await http.post(
      Uri.parse('$apiUrl/sign-in/kakao/$type'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'accessToken': token.accessToken,
      }),
    );
    if (response.statusCode == 200) {
      var newToken = jsonDecode(utf8.decode(response.bodyBytes))['data']['accessToken'];
      var newRefreshToken = jsonDecode(utf8.decode(response.bodyBytes))['data']['refreshToken'];
      prefs.setString('accessToken', newToken);
      prefs.setString('refreshToken', newRefreshToken);
      prefs.setString('type', type);
      print("여기까진 옴");
      Member member = await memberDetail();
      print("여기까지 2");
      return member;
    } else {
      throw Exception("kakao 실패");
    }
  }
}
