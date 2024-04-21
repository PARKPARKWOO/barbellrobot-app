class SignUpMemberDetails {
  String email;
  String password;
  String nickname;
  String gender;
  int? age;
  double? height;
  double? weight;
  double? skeletalMuscleMass;
  int? exerciseMonths;
  String authenticationString;

  SignUpMemberDetails({
    required this.email,
    required this.password,
    required this.nickname,
    required this.gender,
    required this.authenticationString,
    this.age,
    this.height,
    this.weight,
    this.skeletalMuscleMass,
    this.exerciseMonths,
  });
}

class SignUpTrainerDetails {
  String email;
  String password;
  String nickname;
  String gender;
  String authenticationString;
  SignUpTrainerDetails({
    required this.email,
    required this.password,
    required this.nickname,
    required this.gender,
    required this.authenticationString,
  });
}