import '../../../config/app_configs.dart';
import '../../../data/model/request/CustomHttpClient.dart';

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
