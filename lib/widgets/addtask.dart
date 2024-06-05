import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/task_provider.dart';

class AddTask extends StatefulWidget {
  const AddTask();

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final taskNameController = TextEditingController();
  final taskDuedateController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final taskProvider = Provider.of<TaskProvider>(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Text(
              "Create New Task",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              cursorColor: Theme.of(context).primaryColor,
              controller: taskNameController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: 'Title',
                floatingLabelStyle:
                    TextStyle(color: Theme.of(context).primaryColor),
                hintText: 'Enter Task Title ',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              readOnly: true,
              controller: taskDuedateController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: "Due Date",
                floatingLabelStyle:
                    TextStyle(color: Theme.of(context).primaryColor),
                hintText: 'Select Task Duedate ',
              ),
              //readOnly: true,
              onTap: () async {
                //FocusScope.of(context).requestFocus(new FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Theme.of(context)
                            .primaryColor, // Header background color
                        colorScheme: ColorScheme.light(
                            primary: Theme.of(context).primaryColor),
                        buttonTheme: const ButtonThemeData(
                          textTheme: ButtonTextTheme.primary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    taskDuedateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
            ),
            const SizedBox(height: 5),
            if (!isLandscape)
              SizedBox(height: MediaQuery.of(context).size.height * 0.18),
            SizedBox(
              width:
                  MediaQuery.of(context).size.width, // Adjust width as needed
              child: ElevatedButton(
                onPressed: () {
                  if (taskNameController.text.isEmpty || selectedDate == null) {
                    return;
                  }
                  String newId = taskProvider.newTaskId();
                  Task newTask = Task(
                      id: newId,
                      title: taskNameController.text,
                      duedate: selectedDate);
                  taskProvider.addTask(newTask);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  "Save Task",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
