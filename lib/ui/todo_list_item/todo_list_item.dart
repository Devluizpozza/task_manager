import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_maneger/models/task.dart';

class TodoListItem extends StatelessWidget {
  final Task task;
  final Function(Task) onDelete;

  const TodoListItem({super.key, required this.task, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey.shade200,
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(task.dateTime),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              onDelete(task);
            },
            child: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
