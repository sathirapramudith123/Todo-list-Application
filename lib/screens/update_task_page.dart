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

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

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
      appBar: AppBar(
        title: Text("Update Task"),
        backgroundColor: Colors.indigoAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: 'Note',
                        prefixIcon: Icon(Icons.note_alt),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.indigoAccent),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null)
                              setState(() => selectedDate = picked);
                          },
                          child: Text("Change"),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.indigoAccent),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Start: ${formatTime(startTime)}"),
                              Text("End: ${formatTime(endTime)}"),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            TextButton(
                              onPressed: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: startTime,
                                );
                                if (picked != null)
                                  setState(() => startTime = picked);
                              },
                              child: Text("Start Time"),
                            ),
                            TextButton(
                              onPressed: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: endTime,
                                );
                                if (picked != null)
                                  setState(() => endTime = picked);
                              },
                              child: Text("End Time"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choose Color",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    ColorPicker(
                      selectedColor: selectedColor,
                      onColorSelected:
                          (color) => setState(() => selectedColor = color),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
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
              icon: Icon(Icons.save),
              label: Text("Update Task"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: Colors.indigoAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
