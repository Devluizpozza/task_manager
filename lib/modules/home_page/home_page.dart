import 'package:flutter/material.dart';
import 'package:task_maneger/models/task.dart';
import 'package:task_maneger/ui/snack_bar/snack_bars.dart';
import 'package:task_maneger/ui/todo_list_item/todo_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void pressButton() {}

  final TextEditingController taskController = TextEditingController();

  List<Task> tasks = [];

  void onDelete(Task task) {
    setState(() {
      tasks.remove(task);
    });
    SnackBars.SnackBarError(context,
        content: 'Task ${task.title} has been removed');
  }

  void onCreate() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        Task newTask = Task(
          title: taskController.text,
          dateTime: DateTime.now(),
        );
        SnackBars.SnackBarSuccess(context,
            content: 'Task ${newTask.title} has been created');

        tasks.add(newTask);
        taskController.clear();
      });
    }
  }

  void deleteAll() {
    setState(() {
      tasks = [];
    });
    SnackBars.SnackBarSuccess(context, content: 'All tasks have been deleted');
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
