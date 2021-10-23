import 'package:hive/hive.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';

// ignore: avoid_classes_with_only_static_members
class HabitBox {
  static Box<Habit> getHabitBox() {
    return Hive.box<Habit>("Habits");
  }
}
