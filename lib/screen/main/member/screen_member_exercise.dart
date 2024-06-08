import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/model/exercise/ExerciseItem.dart';

class MemberExercisePage extends StatefulWidget {
  final String userHistoryId;
  final List<ExerciseItemDetail> itemDetailList;

  const MemberExercisePage({
    super.key,
    required this.userHistoryId,
    required this.itemDetailList,
  });

  @override
  State<StatefulWidget> createState() => _MemberExercisePageState();
}

class _MemberExercisePageState extends State<MemberExercisePage> {
  String? selectedArea;
  String? selectedGoal;
  List<ExerciseItemDetail> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    filteredExercises = widget.itemDetailList;
  }

  void filterExercises() {
    setState(() {
      filteredExercises = widget.itemDetailList.where((exercise) {
        final matchesArea = selectedArea == null ||
            exercise.exerciseAreas.any((area) => area.area == selectedArea);
        final matchesGoal = selectedGoal == null ||
            exercise.exerciseGoals.any((goal) => goal.goal == selectedGoal);
        return matchesArea && matchesGoal;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> exerciseAreas = widget.itemDetailList
        .expand((e) => e.exerciseAreas.map((ea) => ea.area))
        .toSet()
        .toList();
    List<String> exerciseGoals = widget.itemDetailList
        .expand((e) => e.exerciseGoals.map((eg) => eg.goal))
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Filter'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Select Area'),
                    value: selectedArea,
                    onChanged: (value) {
                      setState(() {
                        selectedArea = value;
                        filterExercises();
                      });
                    },
                    items: exerciseAreas.map((area) {
                      return DropdownMenuItem(
                        value: area,
                        child: Text(area),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Select Goal'),
                    value: selectedGoal,
                    onChanged: (value) {
                      setState(() {
                        selectedGoal = value;
                        filterExercises();
                      });
                    },
                    items: exerciseGoals.map((goal) {
                      return DropdownMenuItem(
                        value: goal,
                        child: Text(goal),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return ListTile(
                  title: Text(exercise.exerciseName),
                  subtitle: Text('Sets: ${exercise.count}'),
                  trailing: Text('ID: ${exercise.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
