import 'package:flutter/material.dart';
import 'package:task_maneger/models/task.dart';
import 'package:task_maneger/repositories/task_repository.dart';
import 'package:task_maneger/ui/snack_bar/snack_bars.dart';
import 'package:task_maneger/ui/todo_list_item/todo_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController taskController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();

  @override
  void initState() {
    super.initState();
    taskRepository.getTaskList().then(
          (value) => {
            setState(
              () {
                tasks = value;
              },
            ),
          },
        );
  }

  List<Task> tasks = [];
  List<Task> deletedAllTasks = [];
  Task? deletedTask;
  int? deleteTaskPosition;
  String errText = '';

  void restoreTask(Task task, int taskPosition) {
    tasks.insert(taskPosition, task);
  }

  void onDelete(Task task) {
    deletedTask = task;
    deleteTaskPosition = tasks.indexOf(task);
    setState(() {
      tasks.remove(task);
      taskRepository.saveTask(context, tasks);
    });
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text('Task ${task.title} has been removed'),
        ),
        duration: const Duration(milliseconds: 1800),
        backgroundColor: Colors.red,
        shape: const BeveledRectangleBorder(),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Undo',
          onPressed: () {
            setState(() {
              tasks.insert(deleteTaskPosition!, deletedTask!);
              taskRepository.saveTask(context, tasks);
            });
          },
        ),
      ),
    );
  }

  void onCreate() {
    String text = taskController.text;
    if (text.isNotEmpty) {
      setState(() {
        Task newTask = Task(
          title: taskController.text,
          dateTime: DateTime.now(),
        );
        SnackBars.SnackBarSuccess(context,
            content: 'Task ${newTask.title} has been created');

        tasks.add(newTask);
        taskController.clear();
        taskRepository.saveTask(context, tasks);
      });
    } else {
      SnackBars.SnackBarError(context,
          content: 'You need to enter a name to add a task.');
    }
  }

  void deleteAll() {
    if (tasks.isEmpty) {
      SnackBars.SnackBarError(context,
          content: 'There are no tasks to be deleted');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clear all?'),
          content: const Text('Are you sure you want to delete all tasks?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  deletedAllTasks = tasks;
                  tasks = [];
                  taskRepository.saveTask(context, tasks);
                });
                SnackBars.SnackBarError(context,
                    content: 'All your tasks have been deleted');
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Yes'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Adicione uma Tarefa',
                          hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d8f3),
                              width: 2,
                            ),
                          ),
                        ),
                        controller: taskController,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      onPressed: onCreate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(14),
                        shape: const BeveledRectangleBorder(),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task task in tasks)
                        TodoListItem(
                          task: task,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Text('Você possui ${tasks.length} pendentes'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: deleteAll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(14),
                        shape: const BeveledRectangleBorder(),
                      ),
                      child: const Text(
                        'Limpar tudo',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
