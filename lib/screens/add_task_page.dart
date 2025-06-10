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
  Color selectedColor = Colors.red;

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Task", style: TextStyle(color: Colors.white)),
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
                        prefixIcon: Icon(Icons.note),
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
                          child: Text("Select Date"),
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
              icon: Icon(Icons.save, color: Colors.white),
              label: Text("Save Task", style: TextStyle(color: Colors.white)),
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
