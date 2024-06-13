import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String imagePath;

  LoadingScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 50, // 원하는 이미지 너비
          height: 50, // 원하는 이미지 높이
          child: Image.asset('assets/$imagePath'),
          color: Colors.transparent,
        ),
      ),
    );
  }
}

Future<void> _loadData() async {
  await Future.delayed(Duration(seconds: 3)); // 예시로 3초 딜레이 추가
}
