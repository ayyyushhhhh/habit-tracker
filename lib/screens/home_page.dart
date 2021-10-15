import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_table/Notification%20Manager/notification_manager.dart';

import 'package:time_table/screens/habit%20tracker/habit_tracker_screen.dart';
import 'package:time_table/screens/settings/settings_screen.dart';
import 'package:time_table/screens/time%20blocker/time_blocker_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    listenNotifications();
    // hideBottomBar();
    NotificationManger.showNotificationDaily(
        id: 0,
        title: "Win your day",
        body: "Wake up Samurai!, We got a day to plan!",
        payload: "task");
  }

  void hideBottomBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.top]);
  }

  // void listenNotifications() {
  //   NotificationManger.listenNotifications(
  //       onNotification: (String payload) {
  //     if (payload == "task") {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => HabitTrackerScreen(),
  //         ),
  //       );
  //     }
  //   });
  // }
  // }

  void listenNotifications() =>
      NotificationManger.onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String? payload) {
    if (payload == "task") {
      _currentIndex = 1;
    } else {
      _currentIndex = 0;
    }
  }

  int _currentIndex = 0;

  final tabs = [HabitTrackerScreen(), TimeBlockerScreen(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 80,
          // backgroundColor: Colors.teal,
          indicatorColor:
              _currentIndex == 0 ? Colors.purple.shade200 : Colors.teal,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.unfold_less), label: "Habit Tracker"),
            NavigationDestination(
                icon: Icon(Icons.event_note), label: "Plan your Day"),
            NavigationDestination(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),
    ));
  }
}
