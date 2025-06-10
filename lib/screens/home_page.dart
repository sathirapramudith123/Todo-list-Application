import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'add_task_page.dart';
import 'update_task_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredTasks =
        tasks
            .where(
              (t) => t.title.toLowerCase().contains(searchText.toLowerCase()),
            )
            .toList();

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          "To-Do List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigoAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Tasks',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: (val) => setState(() => searchText = val),
            ),
          ),
          Expanded(
            child:
                filteredTasks.isEmpty
                    ? Center(
                      child: Text(
                        'No tasks found',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filteredTasks.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: TaskCard(
                            task: filteredTasks[index],
                            onEdit: () async {
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => UpdateTaskPage(
                                        task: filteredTasks[index],
                                      ),
                                ),
                              );
                              if (updated != null) {
                                setState(() {
                                  final taskIndex = tasks.indexOf(
                                    filteredTasks[index],
                                  );
                                  tasks[taskIndex] = updated;
                                });
                              }
                            },
                            onDelete: () {
                              setState(() {
                                tasks.remove(filteredTasks[index]);
                              });
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final task = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskPage()),
          );
          if (task != null) setState(() => tasks.add(task));
        },
        label: Text("Add Task"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}
