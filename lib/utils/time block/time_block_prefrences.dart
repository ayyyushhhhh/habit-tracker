import 'package:shared_preferences/shared_preferences.dart';

class TasksData {
  static SharedPreferences? tasksPrefrences;
  static void init() async {
    tasksPrefrences = await SharedPreferences.getInstance();
  }

  static void saveTask(String date, List<String> tasks) {
    tasksPrefrences!.setStringList(date, tasks);
  }

  static List<String> getSavedTask(String date) {
    final tasksList = tasksPrefrences!.getStringList(date);
    if (tasksList == null) {
      return [];
    }
    return tasksList;
  }
}
