import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import '/screens/tasks_screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // Application name
            title: 'Task Manager',
            // Application theme data, you can set the colors for the application as
            // you want
            theme: ThemeData(
              textSelectionTheme: const TextSelectionThemeData(
                selectionColor:
                    Colors.green, // Change to your desired gray shade
              ),
              // useMaterial3: false,
              primarySwatch: Colors.green,
              primaryColor: Colors.green,
            ),
            // A widget which will be started on application startup
            home: TasksScreen()));
  }
}
