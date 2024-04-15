import 'dart:convert';

import 'package:health/config/app_configs.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class SignUpMemberRequest {
  final String email;
  final String nickname;
  final String password;
  final String gender;
  final int age;
  final int exerciseMonths;
  final double tall;
  final double weight;
  final double? skeletalMuscleMass;
  final String authenticationString;

  SignUpMemberRequest({
    required this.email,
    required this.nickname,
    required this.password,
    required this.gender,
    required this.age,
    required this.exerciseMonths,
    required this.tall,
    required this.weight,
    this.skeletalMuscleMass,
    required this.authenticationString,
  });

  Map<String, dynamic> toJson() =>
      {
        'email': email,
        'nickname': nickname,
        'password': password,
        'gender': gender,
        'age': age,
        'exerciseMonths': exerciseMonths,
        'tall': tall,
        'weight': weight,
        'skeletalMuscleMass': skeletalMuscleMass,
        'authenticationString': authenticationString,
      };
}

class SignUpTrainerRequest {
  final String email;
  final String nickname;
  final String password;
  final String gender;
  final int exerciseYears;
  final String gymName;
  final String street;
  final String city;
  final String country;
  final String introduce;
  final String authenticationString;

  SignUpTrainerRequest({
    required this.email,
    required this.nickname,
    required this.password,
    required this.gender,
    required this.exerciseYears,
    required this.gymName,
    required this.street,
    required this.city,
    required this.country,
    required this.introduce,
    required this.authenticationString,
  });

  Map<String, dynamic> toJson() =>
      {
        'email': email,
        'nickname': nickname,
        'password': password,
        'gender': gender,
        'exerciseYears': exerciseYears,
        'gymName': gymName,
        'street': street,
        'city': city,
        'country': country,
        'introduce': introduce,
        'authenticationString': authenticationString,
      };
}

Future<void> signUp({
  required String email,
  required String nickname,
  required String password,
  required String gender,
  int? age,
  int? exerciseMonths,
  double? tall,
  double? weight,
  double? skeletalMuscleMass,
  int? exerciseYears,
  String? gymName,
  String? street,
  String? city,
  String? country,
  String? introduce,
  required String authenticationString,
  required String type,
}) async {
  final baseUrl = '10.0.2.2';
  final apiUrl = AppConfigs().apiUrl;
  final url = Uri.parse('$apiUrl/sign-up/email/$type');

  var requestBody;

  if (type == 'member') {
    requestBody = SignUpMemberRequest(
      email: email,
      nickname: nickname,
      password: password,
      gender: gender,
      age: age ?? 0,
      // 기본값을 제공하거나 필수 필드로 처리
      exerciseMonths: exerciseMonths ?? 0,
      // 기본값을 제공하거나 필수 필드로 처리
      tall: tall ?? 0.0,
      // 기본값을 제공하거나 필수 필드로 처리
      weight: weight ?? 0.0,
      // 기본값을 제공하거나 필수 필드로 처리
      skeletalMuscleMass: skeletalMuscleMass,
      authenticationString: authenticationString,
    ).toJson();
  } else if (type == 'trainer') {
    requestBody = SignUpTrainerRequest(
      email: email,
      nickname: nickname,
      password: password,
      gender: gender,
      exerciseYears: exerciseYears ?? 0,
      // 기본값을 제공하거나 필수 필드로 처리
      gymName: gymName ?? '',
      // 기본값을 제공하거나 필수 필드로 처리
      street: street ?? '',
      // 기본값을 제공하거나 필수 필드로 처리
      city: city ?? '',
      // 기본값을 제공하거나 필수 필드로 처리
      country: country ?? '',
      // 기본값을 제공하거나 필수 필드로 처리
      introduce: introduce ?? '',
      // 기본값을 제공하거나 필수 필드로 처리
      authenticationString: authenticationString,
    ).toJson();
  }

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    print('회원가입 성공: ${response.body}');
  } else {
    print('회원가입 실패: ${response.statusCode}');
  }
}
