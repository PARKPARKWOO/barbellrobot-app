import 'package:health/data/model/request/CustomHttpClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/app_configs.dart';

class Member {
  String role;
  String? profile;
  MemberInfo? memberInfo;

  Member({
    required this.role,
    this.profile,
    this.memberInfo,
  });

  Member.fromMap(Map<String, dynamic> map)
      : role = map['role'],
        profile = map['profile'],
        memberInfo = map['memberInfoResponse'] != null
            ? MemberInfo.fromMap(map['memberInfoResponse'])
            : null;

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'profile': profile,
      'memberInfo': memberInfo?.toMap(),
    };
  }
}

class MemberInfo {
  String nickname;
  int exerciseMonths;
  double tall;
  double weight;
  double? skeletalMuscleMass;
  int age;
  String gender;

  MemberInfo({
    required this.nickname,
    required this.exerciseMonths,
    required this.tall,
    required this.weight,
    this.skeletalMuscleMass,
    required this.age,
    required this.gender,
  });

  MemberInfo.fromMap(Map<String, dynamic> map)
      : nickname = map['nickname'],
        exerciseMonths = map['exerciseMonths'],
        tall = map['tall'].toDouble(),
        weight = map['weight'].toDouble(),
        skeletalMuscleMass = map['skeletalMuscleMass']?.toDouble(),
        age = map['age'],
        gender = map['gender'];

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'exerciseMonths': exerciseMonths,
      'tall': tall,
      'weight': weight,
      'skeletalMuscleMass': skeletalMuscleMass,
      'age': age,
      'gender': gender,
    };
  }
}

Future<Member> memberDetail() async {
  var baseUrl = AppConfigs().apiUrl;
  var apiUrl = '$baseUrl/member'; // Your API endpoint
  var httpClient = CustomHttpClient();

  var response = await httpClient.get<Member>(apiUrl, create: (json) {
    return Member.fromMap(json);
  });
  if (response is ApiResponse<Member>) {
    return response.data;
  } else {
    throw Exception('member detail');
  }
}
