import 'dart:async';

class Member {
  String nickname;
  String email;
  String role;
  String gender;
  String? provider;
  int exerciseMonths;
  double tall;
  double weight;
  double? skeletalMuscleMass;
  int age;
  String? profile;

  // 생성자에서 모든 필수 필드를 초기화합니다. 선택적 필드는 널러블 타입으로 선언되어 있습니다.
  Member({
    required this.nickname,
    required this.email,
    required this.role,
    required this.gender,
    this.provider,
    required this.exerciseMonths,
    required this.tall,
    required this.weight,
    this.skeletalMuscleMass,
    required this.age,
    this.profile,
  });

  // fromMap 생성자를 사용하여 맵 객체로부터 Member 인스턴스를 생성합니다.
  Member.fromMap(Map<String, dynamic> map)
      : nickname = map['nickname'],
        email = map['email'],
        role = map['role'],
        gender = map['gender'],
        provider = map['provider'],
        exerciseMonths = map['exerciseMonths'],
        tall = map['tall'].toDouble(), // JSON에서는 double이 아닌 int로 올 수 있으므로, toDouble()을 사용하여 변환합니다.
        weight = map['weight'].toDouble(), // 마찬가지로 toDouble()을 사용합니다.
        skeletalMuscleMass = map['skeletalMuscleMass']?.toDouble(), // 널러블 필드이므로, null이 아닐 때만 toDouble()을 호출합니다.
        age = map['age'],
        profile = map['profile'];

  // toMap 메서드를 추가하여 Member 인스턴스를 맵 객체로 변환할 수 있습니다.
  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'email': email,
      'role': role,
      'gender': gender,
      'provider': provider,
      'exerciseMonths': exerciseMonths,
      'tall': tall,
      'weight': weight,
      'skeletalMuscleMass': skeletalMuscleMass,
      'age': age,
      'profile': profile,
    };
  }
}
