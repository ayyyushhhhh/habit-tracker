import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_table/Notification%20Manager/notification_manager.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';
import 'package:time_table/screens/habit%20tracker/add_name_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_table/screens/home_page.dart';
import 'package:time_table/utils/habit%20tracker/prefrences.dart';
import 'package:time_table/utils/habit%20tracker/theme_provider.dart';
import 'package:time_table/utils/time%20block/time_block_prefrences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'models/time_blocker/time_block_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefrences.init();
  TasksData.init();
  tz.initializeTimeZones();
  NotificationManger.init();
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

  @override
  Widget build(BuildContext context) {
    _resetSavedData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManager>(
          create: (context) => ThemeManager(),
        ),
        ChangeNotifierProvider<TasksNotifier>(
          create: (context) => TasksNotifier(),
        ),
      ],
      child: Consumer<ThemeManager>(
        builder: (BuildContext context, value, Widget? child) => MaterialApp(
          title: 'Habit Tracker',
          debugShowCheckedModeBanner: false,
          theme: value.appTheme,
          home: Prefrences.getuserName() == "" ? AddNameScreen() : HomePage(),
        ),
      ),
    );
  }
}
