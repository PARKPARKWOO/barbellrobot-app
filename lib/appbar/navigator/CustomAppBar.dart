// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../config/app_configs.dart';
// import '../../data/model/ai/ConsultingModel.dart';
// import '../../data/model/request/CustomHttpClient.dart';
//
// class CustomMemberTopAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const CustomMemberTopAppBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text('Menu AppBar'),
//       leading: PopupMenuButton<int>(
//         icon: Icon(Icons.menu),
//         onSelected: (int result) {
//           if (result == 0) {
//             _showInputDialog(context);
//           } else if (result == 1) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('로그아웃 선택됨')),
//             );
//             // Perform logout action
//           }
//         },
//         itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
//           PopupMenuItem<int>(
//             value: 0,
//             child: Text('PT 받기'),
//           ),
//           PopupMenuItem<int>(
//             value: 1,
//             child: Text('로그아웃'),
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.home),
//           onPressed: () {
//             Navigator.of(context).pushNamed('/');
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.settings),
//           onPressed: () {
//             Navigator.of(context).pushNamed('/settings');
//           },
//         ),
//       ],
//     );
//   }
//
//   void _showInputDialog(BuildContext context) {
//     final TextEditingController dayController = TextEditingController();
//     final TextEditingController timeController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('PT 받기'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: dayController,
//                   decoration: InputDecoration(labelText: 'Day'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: timeController,
//                   decoration: InputDecoration(labelText: 'Time'),
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('취소'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('확인'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _showPTModal(context, int.parse(dayController.text), int.parse(timeController.text));
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showPTModal(BuildContext context, int day, int time) async {
//     var baseUrl = AppConfigs().apiUrl;
//     var apiUrl = '$baseUrl/pt'; // Your API endpoint
//     var httpClient = CustomHttpClient();
//
//     var body = {"day": day, "time": time};
//     var response = await httpClient.post<ConsultingModel>(apiUrl, body: body,
//         create: (json) {
//           return ConsultingModel.fromJson(json);
//         });
//
//     try {
//
//       if (context.mounted) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('PT 받기'),
//               content: response is ApiResponse<ConsultingModel>
//                   ? SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(response.data.greetingMessage,
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     Text("운동 루틴:"),
//                     for (var i = 0; i < response.data.days.length; i++)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${i + 1}일차: ${response.data.days[i].target}",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           for (var exercise in response.data.days[i].consultingExercise)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 4.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("운동 ID: ${exercise.exerciseId}"),
//                                   Text("세트: ${exercise.set}"),
//                                   Text("무게: ${exercise.weight}"),
//                                   Text("횟수: ${exercise.count}"),
//                                   Text("조언: ${exercise.advice}"),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       ),
//                     SizedBox(height: 10),
//                     Text("경고: ${response.data.warn}"),
//                     Text("팁: ${response.data.tip}"),
//                   ],
//                 ),
//               )
//                   : Text((response as ErrorResponse).message),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('닫기'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     } catch (e) {
//       // Handle any errors that occur during the request
//       print("Error: $e");
//       if (context.mounted) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Error'),
//               content: Text('An error occurred. Please try again later.'),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('닫기'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }
