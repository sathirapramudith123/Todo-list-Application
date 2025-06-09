import 'package:flutter/material.dart';
import 'package:todolistapplication/utils/constants.dart';
import 'package:todolistapplication/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  TaskCard({required this.task, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: task.color,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(task.title, style: whiteText),
        subtitle: Text(
          '${task.startTime.format(context)} - ${task.endTime.format(context)}',
          style: whiteText,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit, color: Colors.white),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
