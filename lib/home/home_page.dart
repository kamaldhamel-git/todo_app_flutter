import 'package:flutter/material.dart';
import 'package:todo/home/widget/task_list_widget.dart';
import 'package:todo/storage/shared_preference.dart';

import 'model/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // To store the task in a list.
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when the HomePage is initialized
  }

  //load tasks from shared preferences.
  Future<void> _loadTasks() async {
    // To get the list of tasks
    tasks = await SharedStorage.instance.getTaskList();
    // To refresh the UI with the loaded tasks
    setState(() {});
  }

  // Navigate to the AddTask screen and reload tasks after returning.
  void _navigateAndReloadTasks(BuildContext context,
      {Task? task, int? index}) async {
    final result = await Navigator.of(context).pushNamed(
      '/addTask',
      arguments: {
        'task': task,
        'index': index,
      },
    );
    // ignore: unrelated_type_equality_checks
    if (result != null && result == true) {
      // reload tasks if a task is saved.
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todo List",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: tasks.length, // Number of tasks to display
        itemBuilder: (context, index) {
          // Get the task at the current index
          final task = tasks[index];
          return TaskList(
            // Pass the task to the TaskListTile widget
            task: task,
            onEdit: () {
              // Handle task editing
              _navigateAndReloadTasks(context, task: task, index: index);
            },
            onDelete: () async {
              // Handle task deletion
              await SharedStorage.instance.deleteTask(index);
              // reload after deletion
              _loadTasks();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          // Navigate to add a new task
          _navigateAndReloadTasks(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
