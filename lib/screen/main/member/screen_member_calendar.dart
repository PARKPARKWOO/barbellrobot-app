import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/model/history/HistoryModel.dart';

class CalendarPage extends StatefulWidget {
  final List<TodayHistoryModel> historyList;

  const CalendarPage({super.key, required this.historyList});

  @override
  State<StatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    // 여기서 필요한 리소스를 해제합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 운동 기록'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              locale: 'ko_KR',
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle().copyWith(color: Colors.red),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle().copyWith(color: Colors.red),
              ),
              onDaySelected: _onDaySelected,
            ),
          ],
        ),
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    // 일치하는 UserHistory 및 ExerciseHistory 정보를 찾고 표시
    List<TodayHistoryModel> matchedHistories =
        widget.historyList.where((historyModel) {
      return isSameDay(historyModel.today, selectedDay);
      // ||
      // historyModel.exerciseHistoryResponse.any((e) => isSameDay(e.createdAt, selectedDay));
    }).toList();

    if (matchedHistories.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('이날은 뭐했을까요~'),
            // TODO: 운동, 식단 입력하기 칸 추가
            content: SingleChildScrollView(
              child: ListBody(
                children: matchedHistories.expand((history) {
                  List<Widget> children = [
                    Text('User History for ${history.today}:'),
                    Text('Attendance: ${history.attendance}'),
                    Text(
                        'Breakfast Image URIs: ${history.breakfastImageUri.join(", ")}'),
                    Text(
                        'Lunch Image URIs: ${history.lunchImageUri.join(", ")}'),
                    Text(
                        'Dinner Image URIs: ${history.dinnerImageUri.join(", ")}'),
                    Text(
                        'Today Image URIs: ${history.todayImageUri.join(", ")}'),
                    Text(
                        'Today Video URIs: ${history.todayVideoUri.join(", ")}'),
                  ];
                  children.addAll(
                      history.exerciseHistoryResponse.map((exerciseHistory) {
                    return Text(
                        'Exercise History ID: ${exerciseHistory.id}, Weight: ${exerciseHistory.weight}');
                  }));
                  return children;
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('이날은 운동안했어요 ㅠ'),
            actions: <Widget>[
              // TODO: 운동, 식단 입력하기 칸 추가
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool isSameDay(DateTime? date1, DateTime date2) {
    if (date1 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
