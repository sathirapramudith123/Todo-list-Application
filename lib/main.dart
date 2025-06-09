import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const TodoListScreen(),
    );
  }
}

class Todo {
  String title;
  DateTime? dateTime;

  Todo({required this.title, this.dateTime});
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _editTodoController = TextEditingController();
  DateTime? _selectedDateTime;
  int? _editingIndex;

  void _addTodo() {
    if (_todoController.text.trim().isNotEmpty) {
      setState(() {
        _todos.add(
          Todo(title: _todoController.text.trim(), dateTime: _selectedDateTime),
        );
        _todoController.clear();
        _selectedDateTime = null;
      });
      _showSnackBar('Task added successfully!', Colors.green);
    } else {
      _showAlertDialog('Empty Task', 'Please enter a task before adding.');
    }
  }

  void _startEditing(int index) {
    _editingIndex = index;
    _editTodoController.text = _todos[index].title;
    _selectedDateTime = _todos[index].dateTime;
    _showEditDialog();
  }

  void _updateTodo() {
    if (_editTodoController.text.trim().isNotEmpty) {
      setState(() {
        _todos[_editingIndex!] = Todo(
          title: _editTodoController.text.trim(),
          dateTime: _selectedDateTime,
        );
        _editTodoController.clear();
        _selectedDateTime = null;
        _editingIndex = null;
      });
      _showSnackBar('Task updated successfully!', Colors.blue);
    } else {
      _showAlertDialog('Empty Task', 'Please enter a task before updating.');
    }
  }

  void _removeTodo(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _todos.removeAt(index);
                });
                Navigator.of(context).pop();
                _showSnackBar('Task deleted successfully!', Colors.red);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime:
            _selectedDateTime != null
                ? TimeOfDay.fromDateTime(_selectedDateTime!)
                : TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _editTodoController,
                  decoration: const InputDecoration(hintText: 'Edit your task'),
                  autofocus: true,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Pick Date & Time'),
                  onPressed: _pickDateTime,
                ),
                const SizedBox(height: 8),
                if (_selectedDateTime != null)
                  Text(
                    'Selected: ${DateFormat('yyyy-MM-dd – hh:mm a').format(_selectedDateTime!)}',
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _editingIndex = null;
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _updateTodo();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTodos =
        _searchController.text.isEmpty
            ? _todos
            : _todos
                .where(
                  (todo) => todo.title.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
                )
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
        actions: [
          if (_todos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Clear All Tasks'),
                        content: const Text(
                          'Are you sure you want to delete all tasks?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() => _todos.clear());
                              Navigator.pop(context);
                              _showSnackBar(
                                'All tasks cleared!',
                                Colors.deepOrange,
                              );
                            },
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      hintText: 'What needs to be done?',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDateTime,
                ),
                FloatingActionButton.small(
                  onPressed: _addTodo,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                filteredTodos.isEmpty
                    ? const Center(child: Text('No tasks found.'))
                    : ListView.builder(
                      itemCount: filteredTodos.length,
                      itemBuilder: (context, index) {
                        final todo = filteredTodos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: ListTile(
                            title: Text(todo.title),
                            subtitle:
                                todo.dateTime != null
                                    ? Text(
                                      DateFormat(
                                        'yyyy-MM-dd – hh:mm a',
                                      ).format(todo.dateTime!),
                                    )
                                    : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _startEditing(index),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeTodo(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _todoController.dispose();
    _editTodoController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
