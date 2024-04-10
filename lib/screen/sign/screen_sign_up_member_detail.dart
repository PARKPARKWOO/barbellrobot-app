import 'package:flutter/material.dart';
import 'package:health/data/model/user/sign/SignUpDetails.dart';

class SignUpMemberPageTwo extends StatefulWidget {
  final SignUpMemberDetails signUpDetails;

  SignUpMemberPageTwo({Key? key, required this.signUpDetails}) : super(key: key);

  @override
  _SignUpMemberPageTwoState createState() => _SignUpMemberPageTwoState();
}

class _SignUpMemberPageTwoState extends State<SignUpMemberPageTwo> {
  final _formKey = GlobalKey<FormState>();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final skeletalMuscleMassController = TextEditingController();
  final exerciseMonthsController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    skeletalMuscleMassController.dispose();
    exerciseMonthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 - 추가 정보'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: '나이'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: heightController,
                  decoration: InputDecoration(labelText: '키 (cm)'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: '몸무게 (kg)'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: skeletalMuscleMassController,
                  decoration: InputDecoration(labelText: '골격근량 (kg) - 선택 사항'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: exerciseMonthsController,
                  decoration: InputDecoration(labelText: '운동 개월 수'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    // 여기서 최종 회원가입 로직을 처리합니다.
                  },
                  child: Text('회원가입 완료'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
