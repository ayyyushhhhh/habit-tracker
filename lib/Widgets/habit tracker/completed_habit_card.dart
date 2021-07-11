import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';

import 'package:time_table/utils/habit%20tracker/habit_tracker_colors.dart';

class CompletedHabitCard extends StatelessWidget {
  final Habit completedHabit;
  CompletedHabitCard({required this.completedHabit});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: deviceWidth,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kHeadingTextColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Image.asset(
            completedHabit.icon,
            height: deviceHeight / 10,
            width: deviceHeight / 10,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                completedHabit.title,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: deviceWidth / 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                completedHabit.description,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: deviceWidth / 22,
                    color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
