import 'package:flutter/material.dart';

class Task {
  String title;
  String note;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  Color color;

  Task({
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}
