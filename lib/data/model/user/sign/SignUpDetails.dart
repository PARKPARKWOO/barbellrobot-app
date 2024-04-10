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

  SignUpMemberDetails({
    required this.email,
    required this.password,
    required this.nickname,
    required this.gender,
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
  SignUpTrainerDetails({
    required this.email,
    required this.password,
    required this.nickname,
    required this.gender,
  });
}