// import 'dart:collection';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:health/data/model/exercise/ExerciseItem.dart';
// import 'package:health/data/model/history/HistoryModel.dart';
// import 'package:health/screen/main/member/screen_member_calendar.dart';
// import 'package:health/screen/main/member/screen_member_exercise.dart';
//
// import '../../../appbar/navigator/CustomAppBar.dart';
// import '../../../data/model/history/StartExercise.dart';
//
// class MemberMainPage extends StatefulWidget {
//   const MemberMainPage({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _MemberMainPageState();
// }
//
// class _MemberMainPageState extends State<MemberMainPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomMemberTopAppBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 DateTime month = DateTime.now();
//                 String key = '${month.year}-${month.month}';
//                 var historyList = await historyRequest();
//                 var historyMap = <String, List<TodayHistoryModel>>{}; // 빈 맵 생성
//                 historyMap[key] = historyList; // 키-값 쌍 추가
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         CalendarPage(historyMap: historyMap, ),
//                   ),
//                 );
//               },
//               child: Text('운동 기록 보기'),
//             ),
//             SizedBox(height: 20), // 버튼 사이의 간격
//             ElevatedButton(
//               onPressed: () async {
//                 String userHistoryId = await loadTodayHistoryId();
//                 List<ExerciseItemDetail> exerciseItemDetail = await findAllItemDetail();
//                 // "운동 시작하기" 버튼 로직
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         MemberExercisePage(userHistoryId: userHistoryId, itemDetailList: exerciseItemDetail),
//                   ),
//                 );
//               },
//               child: Text('운동 시작하기'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
