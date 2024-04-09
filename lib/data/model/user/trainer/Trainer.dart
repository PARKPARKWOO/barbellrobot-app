class Trainer {
  String id;
  String nickname;
  String email;
  String role;
  String gender;
  String gymName;
  String street;
  String city;
  String country;
  int exerciseYears;
  String? introduce;

  Trainer({
    required this.id,
    required this.nickname,
    required this.email,
    required this.role,
    required this.gender,
    required this.gymName,
    required this.street,
    required this.city,
    required this.country,
    required this.exerciseYears,
    this.introduce,
  });

  factory Trainer.fromMap(Map<String, dynamic> map) {
    return Trainer(
      id: map['id'],
      nickname: map['nickname'],
      email: map['email'],
      role: map['role'],
      gender: map['gender'],
      gymName: map['gymName'],
      street: map['street'],
      city: map['city'],
      country: map['country'],
      exerciseYears: map['exerciseYears'],
      introduce: map['introduce'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'role': role,
      'gender': gender,
      'gymName': gymName,
      'street': street,
      'city': city,
      'country': country,
      'exerciseYears': exerciseYears,
      'introduce': introduce,
    };
  }
}
