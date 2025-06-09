import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/color_picker.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  Color selectedColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            ElevatedButton(
              child: Text("Select Date"),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            Row(
              children: [
                ElevatedButton(
                  child: Text("Start Time"),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (picked != null) setState(() => startTime = picked);
                  },
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  child: Text("End Time"),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (picked != null) setState(() => endTime = picked);
                  },
                ),
              ],
            ),
            ColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (color) => setState(() => selectedColor = color),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: _titleController.text,
                  note: _noteController.text,
                  date: selectedDate,
                  startTime: startTime,
                  endTime: endTime,
                  color: selectedColor,
                );
                Navigator.pop(context, newTask);
              },
              child: Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}
