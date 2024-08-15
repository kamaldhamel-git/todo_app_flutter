import 'package:flutter/material.dart';
import 'package:todo/home/model/task.dart';

// Widget to display each task in a card
class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task; // The task to display
  final VoidCallback onEdit; // Callback for editing the task
  final VoidCallback onDelete; // Callback for deleting the task

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(
          task.title, // Display the task title
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(task.description), // Display the task description
        trailing: Wrap(
          spacing: 12, // space between icons
          children: [
            IconButton(
              onPressed: onEdit, // Handle edit button press
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: onDelete, // Handle delete button press
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
