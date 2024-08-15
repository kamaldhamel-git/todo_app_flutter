import 'package:flutter/material.dart';
import 'package:todo/storage/shared_preference.dart';
import 'home/home_page.dart';
import 'home/add_task.dart';

// void main() {
//   runApp(
//     const Todo(),
//   );
// }
void main() async {
  // Ensure Flutter engine is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the shared preferences storage
  await SharedStorage.initializeSharedPref();
  runApp(
    const Todo(),
  );
}

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // to remove water mark of "debug".
      // title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // brightness: Brightness.dark,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/addTask": (context) => const AddTask(),
      },
      // home: const HomePage(), // Set HomePage as the home widget
    );
  }
}
