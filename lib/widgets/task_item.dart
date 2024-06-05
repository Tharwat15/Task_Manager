import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:intl/intl.dart';
import '../task_provider.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  const TaskItem(this.task);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(task.duedate!);
    return Opacity(
      opacity: task.isCompleted ? 0.5 : 1.0,
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) =>
            Provider.of<TaskProvider>(context, listen: false)
                .deleteTask(task.id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: SizedBox(
          height: 200,
          child: Card(
            color: Colors.white,
            elevation: 4,
            child: ListTile(
              title: Text(
                task.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Text("Due Date: $formattedDate"),
              trailing: CircleAvatar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.25),
                child: IconButton(
                  icon: Icon(
                    Icons.done,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Provider.of<TaskProvider>(context, listen: false)
                        .toggleIsCompleted(task.id);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
