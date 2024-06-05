import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../widgets/addtask.dart';
import '../widgets/task_item.dart';
import '../task_provider.dart';

class TasksScreen extends StatefulWidget {
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late List<Task> filterdTasks = [];
  int selectedButtonIndex = 0;

  @override
  void initState() {
    _loadTasks();
    super.initState();
  }

  void _loadTasks() async {
    await Provider.of<TaskProvider>(context, listen: false)
        .loadTasksFromLocalStorage()
        .then((_) {
      setState(() {
        filterdTasks = Provider.of<TaskProvider>(context, listen: false).tasks;
      });
    });
  }

  void setSelectedButton(int index) {
    setState(() {
      selectedButtonIndex = index;
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (index == 0) {
        filterdTasks = taskProvider.tasks;
      } else if (index == 1) {
        filterdTasks = taskProvider.tasks
            .where((task) => task.isCompleted == false)
            .toList();
      } else if (index == 2) {
        filterdTasks = taskProvider.tasks
            .where((task) => task.isCompleted == true)
            .toList();
      }
    });
  }

  void addTask() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const AddTask();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TaskProvider>(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Good Morning",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: isLandscape
            ? [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                      onPressed: addTask,
                      icon: const Icon(Icons.add),
                      color: Colors.white),
                )
              ]
            : [],
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.25),
                    backgroundColor: selectedButtonIndex == 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withOpacity(0.25),
                    shadowColor: Colors.transparent,
                  ).copyWith(
                    foregroundColor: MaterialStateProperty.all(
                      selectedButtonIndex == 0
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () => setSelectedButton(0),
                  child: const Text("All"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.25),
                    backgroundColor: selectedButtonIndex == 1
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withOpacity(0.25),
                    shadowColor: Colors.transparent,
                  ).copyWith(
                    foregroundColor: MaterialStateProperty.all(
                      selectedButtonIndex == 1
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () => setSelectedButton(1),
                  child: const Text("Not Done"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.25),
                    backgroundColor: selectedButtonIndex == 2
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withOpacity(0.25),
                    shadowColor: Colors.transparent,
                  ).copyWith(
                    foregroundColor: MaterialStateProperty.all(
                      selectedButtonIndex == 2
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () => setSelectedButton(2),
                  child: const Text("Done"),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: filterdTasks.isEmpty
                    ? const Center(
                        child: Text(
                          "You have no tasks yet!",
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount =
                              (constraints.maxWidth ~/ 250).clamp(1, 4);
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio:
                                  3.5, // Adjust this to fit your item design
                            ),
                            itemCount: filterdTasks.length,
                            itemBuilder: (context, index) {
                              return TaskItem(filterdTasks[index]);
                            },
                          );
                        },
                      ),
              ),
            ),
            if (!isLandscape)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: addTask,
                  child: const Text(
                    "Add Task",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
