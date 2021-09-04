import 'package:shared_preferences/shared_preferences.dart';

class TasksData {
  static SharedPreferences? tasksPrefrences;
  static void init() async {
    tasksPrefrences = await SharedPreferences.getInstance();
  }

  static void saveTask(String date, List<String> tasks) {
    tasksPrefrences!.setStringList(date, tasks);
  }

  static void updateTask() {}

  static List<String> getSavedTask(String date) {
    final tasksList = tasksPrefrences!.getStringList(date);
    if (tasksList == null) {
      return [];
    }
    return tasksList;
  }

  static void saveTimeLocale(int t) {
    tasksPrefrences!.setInt("is24", t);
  }

  static dynamic getTimeLocale() {
    int? is24 = tasksPrefrences!.getInt("is24");
    if (is24 == null) {
      return "";
    }
    return is24;
  }
}
