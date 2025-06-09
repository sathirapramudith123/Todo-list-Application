import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/color_picker.dart';

class UpdateTaskPage extends StatefulWidget {
  final Task task;

  UpdateTaskPage({required this.task});

  @override
  _UpdateTaskPageState createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late DateTime selectedDate;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _noteController = TextEditingController(text: widget.task.note);
    selectedDate = widget.task.date;
    startTime = widget.task.startTime;
    endTime = widget.task.endTime;
    selectedColor = widget.task.color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Task")),
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
                final updatedTask = Task(
                  title: _titleController.text,
                  note: _noteController.text,
                  date: selectedDate,
                  startTime: startTime,
                  endTime: endTime,
                  color: selectedColor,
                );
                Navigator.pop(context, updatedTask);
              },
              child: Text("Update Task"),
            ),
          ],
        ),
      ),
    );
  }
}
