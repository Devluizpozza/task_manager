import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_maneger/constantes/keys.dart';
import 'package:task_maneger/models/task.dart';
import 'package:task_maneger/ui/snack_bar/snack_bars.dart';

class TaskRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Task>> getTaskList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String jsonString = sharedPreferences.getString(Keys.taskKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded
        .map(
          (e) => (Task.fromJson(e)),
        )
        .toList();
  }

  void saveTask(BuildContext context, List<Task> tasks) async {
    sharedPreferences = await SharedPreferences.getInstance();

    String tasksEcoded = jsonEncode(tasks);
    bool success = await sharedPreferences.setString(Keys.taskKey, tasksEcoded);
    if (!success) {
      SnackBars.SnackBarError(context, content: 'Unable to save tasks');
    }
    SnackBars.SnackBarSuccess(context, content: 'tasks saved successfully');
  }
}
