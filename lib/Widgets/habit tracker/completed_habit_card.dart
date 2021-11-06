import 'package:flutter/material.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';

import 'package:time_table/utils/habit%20tracker/habit_tracker_colors.dart';

class CompletedHabitCard extends StatelessWidget {
  final Habit completedHabit;
  const CompletedHabitCard({required this.completedHabit});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      //  width: deviceWidth,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kHeadingTextColor,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Image.asset(
            completedHabit.icon,
            height: deviceHeight / 10,
            width: deviceHeight / 10,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    completedHabit.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: deviceWidth / 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    completedHabit.description,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: deviceWidth / 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
