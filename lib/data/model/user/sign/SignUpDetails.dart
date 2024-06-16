class SignUpMemberDetails {
  String email;
  String password;
  String? nickname;
  String? gender;
  int? age;
  double? height;
  double? weight;
  double? skeletalMuscleMass;
  int? exerciseMonths;
  String authenticationString;
  String type;

  SignUpMemberDetails({
    required this.email,
    required this.password,
    this.nickname,
    this.gender,
    required this.authenticationString,
    this.age,
    this.height,
    this.weight,
    this.skeletalMuscleMass,
    this.exerciseMonths,
    required this.type,
  });
}

class SignUpTrainerDetails {
  String email;
  String password;
  String authenticationString;
  SignUpTrainerDetails({
    required this.email,
    required this.password,
    required this.authenticationString,
  });
}