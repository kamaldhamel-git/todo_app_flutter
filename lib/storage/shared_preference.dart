import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences package
import '../home/model/task.dart'; // Import the Task model

class SharedStorage {
  SharedStorage._privateConstructor(); // Private constructor for singleton pattern

  static final SharedStorage _instance =
      SharedStorage._privateConstructor(); // Singleton instance

  static SharedStorage get instance =>
      _instance; // Getter for the singleton instance
  static SharedPreferences? _pref; // SharedPreferences instance

  // Initialize the SharedPreferences instance
  static Future<void> initializeSharedPref() async {
    _pref ??= await SharedPreferences
        .getInstance(); // Assign SharedPreferences instance if not already assigned
  }

  // Save the list of tasks to shared preferences
  Future<void> saveTaskList(List<Task> tasks) async {
    List<String> jsonStringList = tasks
        .map((task) => jsonEncode(task.toJson()))
        .toList(); // Convert tasks to a list of JSON strings
    await _pref?.setStringList(
        'task_list', jsonStringList); // Save the list to shared preferences
  }

  // Retrieve the list of tasks from shared preferences
  Future<List<Task>> getTaskList() async {
    List<String>? jsonStringList =
        _pref?.getStringList('task_list'); // Get the list of JSON strings
    if (jsonStringList != null) {
      return jsonStringList
          .map((jsonString) => Task.fromJson(jsonDecode(
              jsonString))) // Convert JSON strings back to Task objects
          .toList();
    }
    return []; // Return an empty list if no tasks are found
  }

  // Add a new task to the task list
  Future<void> addTask(Task task) async {
    List<Task> tasks = await getTaskList(); // Get the current list of tasks
    tasks.add(task); // Add the new task to the list
    await saveTaskList(tasks); // Save the updated list to shared preferences
  }

  // Delete a task from the task list by its index
  Future<void> deleteTask(int index) async {
    List<Task> tasks = await getTaskList(); // Get the current list of tasks
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index); // Remove the task at the specified index
      await saveTaskList(tasks); // Save the updated list to shared preferences
    }
  }

  // Edit an existing task in the task list by its index
  Future<void> editTask(int index, Task newTask) async {
    List<Task> tasks = await getTaskList(); // Get the current list of tasks
    if (index >= 0 && index < tasks.length) {
      tasks[index] =
          newTask; // Replace the task at the specified index with the new task
      await saveTaskList(tasks); // Save the updated list to shared preferences
    }
  }
}
