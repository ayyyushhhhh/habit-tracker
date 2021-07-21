import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';
import 'package:time_table/models/time_blocker/time_block_model.dart';
import 'package:time_table/screens/habit%20tracker/add_name_screen.dart';
import 'package:time_table/screens/habit%20tracker/habit_tracker_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_table/screens/time%20blocker/time_blocker_screen.dart';
import 'package:time_table/utils/habit%20tracker/prefrences.dart';
import 'package:time_table/utils/habit%20tracker/theme_provider.dart';
import 'package:time_table/utils/time%20block/time_block_prefrences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefrences.init();
  TasksData.init();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>("Habits");
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   void _resetSavedData() {
//     if (Prefrences.getDate() !=
//         DateFormat('dd-MM-yyyy').format(DateTime.now())) {
//       final myBox = HabitBox.getHabitBox();
//       List<Habit> allHabits = myBox.values.toList().cast<Habit>();
//       allHabits.forEach((habit) {
//         myBox.put(habit.title, habit.updateWith(isCompleted: false));
//       });
//       Prefrences.saveDate(DateTime.now());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _resetSavedData();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     return ChangeNotifierProvider<ThemeManager>(
//       create: (context) => ThemeManager(),
//       child: Consumer<ThemeManager>(
//         builder: (BuildContext context, value, Widget? child) => MaterialApp(
//           title: 'Habit Tracker',
//           debugShowCheckedModeBanner: false,
//           theme: value.appTheme,
//           home: Prefrences.getuserName() == ""
//               ? AddNameScreen()
//               : HabitTrackerScreen(),
//         ),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TasksNotifier>(
      create: (context) => TasksNotifier(),
      child: MaterialApp(
        title: "Time Blocker",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: TimeBlockerScreen(),
      ),
    );
  }
}
