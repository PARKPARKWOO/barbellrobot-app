import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/screen/main/member/screen_member_calendar.dart';
import 'package:health/screen/main/member/screen_member_exercise.dart';

import '../../../data/model/exercise/ExerciseItem.dart';
import '../../../data/model/history/HistoryModel.dart';
import '../../../data/model/history/StartExercise.dart';
import '../../bar/MemberBottomNaviBar.dart';

class MemberMainPageFromFigma extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MemberMainPageFromFigmaState();
}

class MemberMainPageFromFigmaState extends State<MemberMainPageFromFigma> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToCalendarPage() async {
    DateTime month = DateTime.now();
    String key = '${month.year}-${month.month}';
    var historyList = await historyRequest();
    var historyMap = <String, List<TodayHistoryModel>>{}; // 빈 맵 생성
    historyMap[key] = historyList;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CalendarPage(
            historyMap: historyMap,
          )),
    );
  }

  void _navigateToMemberExercisePage() async {
    String userHistoryId = await loadTodayHistoryId();
    List<ExerciseItemDetail> exerciseItemDetail = await findAllItemDetail();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MemberExercisePage(
            userHistoryId: userHistoryId,
            itemDetailList: exerciseItemDetail,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildTopButtons(),
              const SizedBox(height: 16),
              _buildWeeklySummary(),
              const SizedBox(height: 16),
              _buildStartExerciseButton(),
              const SizedBox(height: 8),
              _buildRecordTodayButton(),
              const SizedBox(height: 16),
              _buildMostSearchedWorkouts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildIconTextButton(
            '💪',
            'AI PT 받기',
            null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildIconTextButton(
            '📅',
            '운동 기록 보기',
            _navigateToCalendarPage,
          ),
        ),
      ],
    );
  }

  Widget _buildIconTextButton(String icon, String text, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Center(
                child: Text(
                  icon,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: double.infinity,
              height: 26,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Summary',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Workout Frequency',
                  '5',
                  '+2',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryItem(
                  'Average Duration',
                  '45 mins',
                  '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, String additionalValue) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          if (additionalValue.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              additionalValue,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStartExerciseButton() {
    return GestureDetector(
      onTap: _navigateToMemberExercisePage,
      child: Container(
        width: double.infinity,
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            '운동 시작하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordTodayButton() {
    return Container(
      width: double.infinity,
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Center(
        child: Text(
          '오늘 뭐 했는지 기록해봐요',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildMostSearchedWorkouts() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '가장 많이 찾는 운동',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildWorkoutItem(
                  'Weightlifting',
                  'Strength',
                  'Bench Press',
                  '4 sets, 12 reps',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildWorkoutItem(
                  'Jogging',
                  'Cardio',
                  'Morning Run',
                  '45 minutes',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(
      String imageName, String category, String name, String details) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 164,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  top: 74,
                  child: SizedBox(
                    width: 132,
                    height: 16,
                    child: Text(
                      imageName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.2,
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
