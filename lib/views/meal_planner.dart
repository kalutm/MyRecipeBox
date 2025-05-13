import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MealPlanner extends StatefulWidget {
  const MealPlanner({super.key});

  @override
  State<MealPlanner> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlanner> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(focusedDay: DateTime.now(), firstDay: DateTime.utc(2010, 7, 7), lastDay: DateTime.utc(2040, 7, 7));
  }
}