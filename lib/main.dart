import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_table/Notification%20Manager/notification_manager.dart';
import 'package:time_table/firebase/cloud_store.dart';
import 'package:time_table/firebase/firebase_authentication.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';
import 'package:time_table/screens/habit%20tracker/add_name_screen.dart';
import 'package:time_table/screens/home_page.dart';
import 'package:time_table/utils/prefrences.dart';
import 'package:time_table/utils/theme_provider.dart';
import 'package:time_table/utils/time%20block/time_block_prefrences.dart';
import 'package:time_table/utils/user_info.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;

import 'firebase/firebase_authentication.dart';
import 'models/time_blocker/time_block_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Prefrences.init();
  TasksData.init();
  FirebaseAuthentication.initFirebaseAuth();
  tz.initializeTimeZones();
  NotificationManger.init();

  await Hive.initFlutter();

  Hive.registerAdapter(HabitAdapter());
  print("1");
  await Hive.openBox<Habit>("Habits");
  print("2");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void _resetSavedData() {
    if (Prefrences.getDate() !=
        DateFormat('dd-MM-yyyy').format(DateTime.now())) {
      final myBox = HabitBox.getHabitBox();
      final List<Habit> allHabits = myBox.values.toList().cast<Habit>();
      for (final habit in allHabits) {
        myBox.put(habit.title, habit.updateWith(isCompleted: false));
      }
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
        ChangeNotifierProvider<User>(
          create: (context) => User(),
        ),
        Provider<CloudData>(
          create: (context) => CloudData(),
        )
      ],
      child: Consumer<ThemeManager>(
        builder: (BuildContext context, value, Widget? child) => MaterialApp(
          title: 'Track and Grow',
          debugShowCheckedModeBanner: false,
          theme: value.appTheme,
          home: Prefrences.getuserName() == ""
              ? const AddNameScreen()
              : const HomePage(),
        ),
      ),
    );
  }
}
