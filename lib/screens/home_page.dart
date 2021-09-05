import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:time_table/screens/habit%20tracker/habit_tracker_screen.dart';
import 'package:time_table/screens/time%20blocker/time_blocker_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final tabs = [
    HabitTrackerScreen(),
    TimeBlockerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: tabs[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.black),
            ),
          ),
          child: BottomNavigationBar(
            elevation: 1,
            type: BottomNavigationBarType.fixed,
            iconSize: 30,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.unfold_less,
                ),
                label: "Tracks Habits",
                backgroundColor: Colors.blue,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.event_note,
                  color: Colors.teal,
                ),
                label: "Plan your Day",
                backgroundColor: Colors.teal,
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
