import 'package:health/util/DateTimeUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_configs.dart';
import '../../../data/model/request/CustomHttpClient.dart';

class Attendance {
  String todayHistoryId;

  Attendance({required this.todayHistoryId});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      todayHistoryId: json['todayHistoryId']
    );
  }
}

Future<String> attendance() async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/history/attendance';
  var http = CustomHttpClient(); // 이 부분은 사용자 정의 HTTP 클라이언트로 가정
  return "";
  // var response = await http.post(apiUrl);
  //
  // if (response.statusCode == 200) {
  //   // JSON 응답을 정확하게 파싱
  //   Map<String, dynamic> jsonResponse = json.decode(response.body);
  //   var userHistoryData = jsonResponse['data']
  //   as List<dynamic>; // 여러 UserHistory 객체를 담고 있는 리스트를 예상
  //
  //   if (userHistoryData != null) {
  //     print(userHistoryData.toString());
  //     // UserHistory 데이터 파싱
  //     return userHistoryData
  //         .map((data) =>
  //         TodayHistoryModel.fromJson(data as Map<String, dynamic>))
  //         .toList();
  //   } else {
  //     throw Exception('User history data is missing in the response');
  //   }
  // } else {
  //   throw Exception('Failed to load user history: ${response.statusCode}');
  // }
}

Future<String> loadTodayHistoryId() async {
  final prefs = await SharedPreferences.getInstance();
  String? savedDate = prefs.getString('todayDate');
  var now = await DateTimeUtil().now();
  if (savedDate != null) {
    DateTime lastSavedDate = DateTime.parse(savedDate);
    if (now.difference(lastSavedDate).inDays > 0) {
      // 날짜가 변경되었으므로 todayHistoryId를 초기화
      await prefs.remove('todayHistoryId');
      await prefs.remove('todayDate');
      String todayHistoryId = await attendance();
      await prefs.setString('todayHistoryId', todayHistoryId);
      await prefs.setString('todayDate', now.toString());
      return todayHistoryId;
    } else {
      return prefs.getString('todayHistoryId')!;
    }
  } else {
    String todayHistoryId = await attendance();
    await prefs.setString('todayHistoryId', todayHistoryId);
    await prefs.setString('todayDate', now.toString());
    return todayHistoryId;
  }
}
