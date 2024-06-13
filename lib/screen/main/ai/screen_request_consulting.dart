import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/data/model/exercise/ExerciseItem.dart';
import 'package:health/screen/main/ai/screen_consulting.dart';

import '../../../data/model/ai/ConsultingModel.dart';
import '../../common/loading.dart';

class ExerciseInputPage extends StatefulWidget {
  @override
  _ExerciseInputPageState createState() => _ExerciseInputPageState();
}

class _ExerciseInputPageState extends State<ExerciseInputPage> {
  final _dayController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _dayController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 360,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '운동 가능한 시간을 알려주세요',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildInputRow(
                  icon: '📅',
                  label: '일주일에 몇일 할 수 있나요?',
                  hintText: '1',
                  controller: _dayController,
                ),
                const SizedBox(height: 12),
                _buildInputRow(
                  icon: '🕒',
                  label: '하루에 몇 분 할 수 있나요?',
                  hintText: '100',
                  controller: _timeController,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: double.infinity,
              height: 42,
              decoration: ShapeDecoration(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: TextButton(
                onPressed: () async {
                  // 로딩 화면 표시
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        insetPadding: EdgeInsets.all(0),
                        child: LoadingScreen(imagePath: 'robot.png'),
                      );
                    },
                  );

                  try {
                    // 비동기 작업 (예: API 호출)
                    int day = int.parse(_dayController.text);
                    int time = int.parse(_timeController.text);
                    var model = await requestConsulting(day, time);
                    var itemDetails = await findAllItemDetail(model.days
                        .expand((day) => day.consultingExercise
                            .map((exercise) => exercise.exerciseId))
                        .toList());

                    // 로딩 화면 닫기
                    Navigator.of(context).pop();

                    // API 호출 후 처리할 로직
                    // 예: 다음 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConsultingPage(
                                model: model,
                                exerciseItemDetails: itemDetails,
                              )),
                    );
                  } catch (e) {
                    // 에러 처리
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('An error occurred: $e'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    // 디버깅을 위해 에러 메시지를 출력합니다.
                    print('An error occurred: $e');
                  }
                },
                child: Text(
                  'PT 받기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInputRow({
    required String icon,
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: ShapeDecoration(
              color: Colors.black.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Center(
              child: Text(
                icon,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: hintText,
                    contentPadding: EdgeInsets.only(top: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
