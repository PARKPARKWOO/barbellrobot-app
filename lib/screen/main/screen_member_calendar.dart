import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/data/model/history/HistoryModel.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final List<UserHistory> historyList;

  const CalendarPage({super.key, required this.historyList});
  @override
  State<StatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    var _focusedDay;
    return Scaffold(
        appBar: AppBar(
          title: Text('내 운동 기록'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 600,
            child: TableCalendar(
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              locale: 'ko_KR',
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
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
              onDaySelected: (selectedDay, focusedDay) {
                // 날짜 선택 로직
              },
            ),
          ),
        ));
  }
}
