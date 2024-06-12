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
  var http = CustomHttpClient();

  var response = await http.post<Attendance>(apiUrl,
      create: (json) {
        return Attendance.fromJson(json);
      });

  if (response is ApiResponse<Attendance>) {
    return response.data.todayHistoryId;
  } else if (response is ErrorResponse) {
    // Handle the error response
    print('Error: ${response.message}');
    return "Error";
  } else {
    throw Exception('Unexpected response type');
  }
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
