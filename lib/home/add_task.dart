import 'package:flutter/material.dart';
import 'package:todo/storage/shared_preference.dart';
import 'model/task.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  // Controller for the task title.
  final titleController = TextEditingController();
  // Controller for the task description.
  final descriptionController = TextEditingController();
  // Flag to check if the task inputs are valid
  bool isTaskInvalid = false;

// this helps me to display the detail task title and description while editing.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments
        as Map?; // Get the passed arguments (task and index)
    if (args != null) {
      final Task? task = args['task']; // Extract the task from the arguments
      if (task != null) {
        titleController.text =
            task.title; // Pre-fill the title input if editing a task
        descriptionController.text = task
            .description; // Pre-fill the description input if editing a task
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Add Your Task",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Title",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: TextField(
              controller:
                  titleController, // Bind the titleController to this input
              decoration: const InputDecoration(
                hintText: "Enter task title",
              ),
            ),
          ),
          ListTile(
            title: const Text(
              "Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: TextField(
              controller:
                  descriptionController, // Bind the descriptionController to this input
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Enter task description",
              ),
            ),
          ),
          if (isTaskInvalid)
            const Center(
              child: Text(
                "Please add your Task", // Error message if the task inputs are invalid
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    // Close the dialog.
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    // Check if the task inputs are empty
                    if (titleController.text.isEmpty ||
                        descriptionController.text.isEmpty) {
                      setState(() {
                        // Set the flag to show the error message
                        isTaskInvalid = true;
                      });
                      return;
                    }
                    // Create a new Task object with the input values
                    final task = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                    );

                    final args = ModalRoute.of(context)?.settings.arguments
                        as Map?; // Get the arguments again
                    if (args != null) {
                      // Extract the index from the arguments
                      final int? index = args['index'];
                      if (index != null) {
                        // to update the task if editing.
                        await SharedStorage.instance.editTask(index, task);
                      } else {
                        // add the task if creating a new one.
                        await SharedStorage.instance.addTask(task);
                      }
                    } else {
                      //add the task if there are no arguments
                      await SharedStorage.instance.addTask(task);
                    }
                    // to close dialog and inform task saving.
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
