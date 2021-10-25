import 'package:flutter/material.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';
import 'package:time_table/utils/habit%20tracker/habit_tracker_colors.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;

  const HabitCard({required this.habit});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  void toggleDoneHabit() {
    if (widget.habit.isDone == false) {
      setState(() {
        widget.habit.isDone = true;

        final habitbox = HabitBox.getHabitBox();
        final DateTime now = DateTime.now();
        final DateTime date = DateTime(now.year, now.month, now.day);
        habitbox.put(
          widget.habit.title,
          widget.habit.updateWith(completeDate: date),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(20),
      height: deviceHeight / 10,
      width: deviceWidth / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kHeadingTextColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.habit.icon,
              width: deviceHeight / 8,
              height: deviceHeight / 8,
            ),
            Text(
              widget.habit.title,
              style: TextStyle(
                fontSize: deviceHeight / 25,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                widget.habit.description,
                maxLines: 2,
                style: TextStyle(
                  fontSize: deviceWidth / 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "(Click here for details)",
              style: TextStyle(fontSize: deviceWidth / 30, color: Colors.blue),
              overflow: TextOverflow.ellipsis,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: toggleDoneHabit,
                icon: const Icon(Icons.check_circle),
                iconSize: deviceHeight / 15,
                color: widget.habit.isDone == false
                    ? Colors.grey
                    : Colors.green.shade900,
              ),
            )
          ],
        ),
      ),
    );
  }
}
