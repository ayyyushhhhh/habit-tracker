import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';
import 'package:time_table/screens/habit%20tracker/add_name_screen.dart';
import 'package:time_table/screens/habit%20tracker/habit_tracker_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_table/utils/habit%20tracker/prefrences.dart';
import 'package:time_table/utils/habit%20tracker/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefrences.init();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>("Habits");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void _resetSavedData() {
    if (Prefrences.getDate() !=
        DateFormat('dd-MM-yyyy').format(DateTime.now())) {
      final myBox = HabitBox.getHabitBox();
      List<Habit> allHabits = myBox.values.toList().cast<Habit>();
      allHabits.forEach((habit) {
        myBox.put(habit.title, habit.updateWith(isCompleted: false));
      });
      Prefrences.saveDate(DateTime.now());
    }
  }

  void _saveSkipDates() {
    if (Prefrences.getDate() !=
        DateFormat('dd-MM-yyyy').format(DateTime.now())) {
      DateTime previousDate = DateTime.now().subtract(Duration(days: 1));
      previousDate =
          DateTime(previousDate.year, previousDate.month, previousDate.day);
      final myBox = HabitBox.getHabitBox();
      List<Habit> allHabits = myBox.values.toList().cast<Habit>();
      allHabits.forEach((habit) {
        print("${habit.completedDates} + ${habit.skipDates}");
        if (!habit.completedDates!.contains(previousDate) &&
            !habit.skipDates!.contains(previousDate)) {
          myBox.put(
            habit.title,
            habit.updateWith(
              skipDate: previousDate,
            ),
          );
        }
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _saveSkipDates();
    _resetSavedData();

    return ChangeNotifierProvider<ThemeManager>(
      create: (context) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (BuildContext context, value, Widget? child) => MaterialApp(
          title: 'Habit Tracker',
          debugShowCheckedModeBanner: false,
          theme: value.appTheme,
          home: Prefrences.getuserName() == ""
              ? AddNameScreen()
              : HabitTrackerScreen(),
        ),
      ),
    );
  }
}
