import 'package:hive/hive.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';

class HabitBox {
  static Box<Habit> getHabitBox() {
    return Hive.box<Habit>("Habits");
  }
}
