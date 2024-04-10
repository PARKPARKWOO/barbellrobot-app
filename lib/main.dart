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
      home: SignInScreen(),
    );
  }
}
