import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/appbar/navigator/CustomAppBar.dart';
import 'package:table_calendar/table_calendar.dart';

class MemberMainPage extends StatefulWidget {
  const MemberMainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MemberMainPageState();
}

class _MemberMainPageState extends State<MemberMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('내 운동 기록'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 600,
            child: TableCalendar(
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
