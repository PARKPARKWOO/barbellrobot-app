import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/data/model/history/HistoryModel.dart';
import 'package:health/screen/main/screen_member_calendar.dart';

import '../../appbar/navigator/CustomAppBar.dart';

class MemberMainPage extends StatefulWidget {
  const MemberMainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MemberMainPageState();
}

class _MemberMainPageState extends State<MemberMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '운동 관리',
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 설정 화면으로 이동 또는 설정 관련 로직
              print('Settings tapped');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var historyList = await historyRequest();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarPage(historyList: historyList),
                  ),
                );
              },
              child: Text('운동 기록 보기'),
            ),
            SizedBox(height: 20),  // 버튼 사이의 간격
            ElevatedButton(
              onPressed: () {
                // "운동 시작하기" 버튼 로직

              },
              child: Text('운동 시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}
