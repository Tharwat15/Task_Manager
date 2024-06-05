import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> tasksList = [];

  List<Task> get tasks => tasksList;

  Future<void> saveTasksToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksJson =
        jsonEncode(tasksList.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);
  }

  Future<void> loadTasksFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      List<dynamic> tasksMap = jsonDecode(tasksJson);
      tasksList = tasksMap.map((taskMap) => Task.fromJson(taskMap)).toList();
      notifyListeners();
    }
  }

  String newTaskId() {
    if (tasksList.isEmpty) {
      return "t1";
    }
    String temp = tasksList[0].id.substring(1);
    int num = 1 + int.parse(temp);
    String newID = "t$num";
    return newID;
  }

  void addTask(Task newTask) {
    tasksList.insert(0, newTask);
    saveTasksToLocalStorage();
    storeTasks(tasksList);
    notifyListeners();
  }

  void toggleIsCompleted(String id) {
    int index = tasksList.indexWhere((task) => task.id == id);
    tasksList[index].isCompleted = !tasksList[index].isCompleted;
    saveTasksToLocalStorage();
    storeTasks(tasksList);
    notifyListeners();
  }

  void deleteTask(String id) {
    tasksList.removeWhere((task) => task.id == id);
    saveTasksToLocalStorage();
    storeTasks(tasksList);
    notifyListeners();
  }

  Future<void> storeTasks(List<Task> tasks) async {
    try {
      final url = Uri.parse(
          'https://taskmanger-906f7-default-rtdb.firebaseio.com/tasks.json');
      final response = await http.put(url,
          body: json.encode(tasks.map((task) => task.toJson()).toList()));

      if (response.statusCode != 200) {
        throw Exception('Failed to store tasks');
      }
    } catch (error) {
      throw Exception('Failed to store tasks: $error');
    }
  }

  // Function to fetch all tasks from Firebase Realtime Database
  Future<void> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse(
          'https://taskmanger-906f7-default-rtdb.firebaseio.com/tasks.json'));

      if (response.statusCode == 200) {
        final List<Task> tasks = [];
        final data = json.decode(response.body) as List;
        for (int i = 0; i < data.length; i++) {
          tasks.add(Task.fromJson(data[i]));
        }
        tasksList = tasks;

        notifyListeners();
      } else {
        throw Exception('Failed to fetch tasks');
      }
    } catch (error) {
      throw Exception('Failed to fetch tasks: $error');
    }
  }
}
