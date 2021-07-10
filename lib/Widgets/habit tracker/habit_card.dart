import 'package:flutter/material.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';
import 'package:time_table/utils/habit%20tracker/habit_tracker_colors.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;

  HabitCard({required this.habit});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  void toggleDoneHabit() {
    setState(() {
      // final habitProv =
      //     Provider.of<HabitTrackerProvider>(context, listen: false);
      // habitProv.addHabitsToCompletedList(habit: widget.habit);
      widget.habit.isDone = true;
      final habitbox = HabitBox.getHabitBox();
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
      habitbox.put(
        widget.habit.title,
        widget.habit.updateWith(completeDate: date),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(20),
      height: deviceHeight / 15,
      width: deviceWidth / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kHeadingTextColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.habit.icon,
              style: TextStyle(
                fontSize: deviceHeight / 13.5,
              ),
            ),
            Text(
              widget.habit.title,
              style: TextStyle(
                  fontSize: deviceHeight / 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.habit.description,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            SizedBox(
              height: 2,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: toggleDoneHabit,
                icon: Icon(Icons.check_circle),
                iconSize: deviceHeight / 20,
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
