import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class TasksData {
  static SharedPreferences? tasksPrefrences;
  static Future<void> init() async {
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
    final int? is24 = tasksPrefrences!.getInt("is24");
    if (is24 == null) {
      return "";
    }
    return is24;
  }
}
