import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../config/app_configs.dart';
import '../../../data/model/history/HistoryModel.dart';
import '../../../data/model/request/CustomHttpClient.dart';

class CalendarPage extends StatefulWidget {
  final Map<String, List<TodayHistoryModel>> historyMap;

  const CalendarPage({super.key, required this.historyMap});

  @override
  State<StatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  late Map<String, List<TodayHistoryModel>> _historyMap;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _historyMap = widget.historyMap;
  }

  Future<void> _fetchHistoryForMonth(DateTime month) async {
    String monthKey = '${month.year}-${month.month}';
    if (_historyMap.containsKey(monthKey)) {
      _historyMap.remove(monthKey);
    }

    var baseUrl = AppConfigs().apiUrl;
    var apiUrl = '$baseUrl/history/month?month=${month.month}&year=${month.year}';
    var httpClient = CustomHttpClient();

    try {
      var response = await httpClient.get<List<TodayHistoryModel>>(apiUrl, create: (json) {
        return (json as List).map((item) => TodayHistoryModel.fromJson(item)).toList();
      });

      if (response is ApiResponse<List<TodayHistoryModel>>) {
        setState(() {
          _historyMap[monthKey] = response.data;
        });
      } else if (response is ErrorResponse) {
        // Handle the error response
        print('Error: ${response.message}');
      } else {
        throw Exception('Unexpected response type');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print("Error: $e");
    }
  }

  List<TodayHistoryModel> _getEventsForDay(DateTime day) {
    String monthKey = '${day.year}-${day.month}';
    if (_historyMap.containsKey(monthKey)) {
      return _historyMap[monthKey]!
          .where((history) => isSameDay(history.today, day))
          .toList();
    }
    return [];
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
                _fetchHistoryForMonth(focusedDay);
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
              eventLoader: _getEventsForDay,
              onDaySelected: _onDaySelected,
            ),
            ..._getEventsForDay(_selectedDay!).map(
                  (history) => ListTile(
                title: Text('User History for ${history.today}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Attendance: ${history.attendance}'),
                    Text('Breakfast Image URIs: ${history.breakfastImageUri.join(", ")}'),
                    Text('Lunch Image URIs: ${history.lunchImageUri.join(", ")}'),
                    Text('Dinner Image URIs: ${history.dinnerImageUri.join(", ")}'),
                    Text('Today Image URIs: ${history.todayImageUri.join(", ")}'),
                    Text('Today Video URIs: ${history.todayVideoUri.join(", ")}'),
                    ...history.exerciseHistoryResponse.map((exerciseHistory) {
                      return Text('Exercise History ID: ${exerciseHistory.id}, Weight: ${exerciseHistory.weight}');
                    }).toList(),
                  ],
                ),
              ),
            ).toList(),
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

    List<TodayHistoryModel> matchedHistories = _getEventsForDay(selectedDay);

    if (matchedHistories.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('이날은 뭐했을까요~'),
            content: SingleChildScrollView(
              child: ListBody(
                children: matchedHistories.expand((history) {
                  List<Widget> children = [
                    Text('User History for ${history.today}:'),
                    Text('Attendance: ${history.attendance}'),
                    Text('Breakfast Image URIs: ${history.breakfastImageUri.join(", ")}'),
                    Text('Lunch Image URIs: ${history.lunchImageUri.join(", ")}'),
                    Text('Dinner Image URIs: ${history.dinnerImageUri.join(", ")}'),
                    Text('Today Image URIs: ${history.todayImageUri.join(", ")}'),
                    Text('Today Video URIs: ${history.todayVideoUri.join(", ")}'),
                  ];
                  children.addAll(history.exerciseHistoryResponse.map((exerciseHistory) {
                    return Text('Exercise History ID: ${exerciseHistory.id}, Weight: ${exerciseHistory.weight}');
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
