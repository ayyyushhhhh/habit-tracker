import 'package:flutter/material.dart';
import 'package:r_calendar/r_calendar.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';
import 'package:time_table/utils/habit%20tracker/habit_tracker_colors.dart';

class HabitSummaryScreen extends StatefulWidget {
  final Habit habit;

  const HabitSummaryScreen({Key? key, required this.habit}) : super(key: key);

  @override
  _HabitSummaryScreenState createState() => _HabitSummaryScreenState();
}

class _HabitSummaryScreenState extends State<HabitSummaryScreen> {
  late RCalendarController controller;
  @override
  void initState() {
    super.initState();

    controller = RCalendarController.multiple(
        selectedDates: widget.habit.completedDates!, isDispersion: true);
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    print(widget.habit.completedDates);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                final habitbox = HabitBox.getHabitBox();
                habitbox.delete(widget.habit.title);
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete))
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(deviceHeight / 8),
          child: Text(
            "Habit Summary",
            style: TextStyle(
                fontSize: deviceHeight / 16, fontWeight: FontWeight.w800),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  "It takes 21 Days to create Habit.",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: kHeadingTextColor),
                ),
              ),
              _habitCalendar(deviceHeight, deviceWidth),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "--- Habit Complete Dates",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _habitCalendar(double deviceHeight, double deviceWidth) {
    return Container(
      height: deviceHeight / 1.9,
      width: deviceWidth,
      decoration: BoxDecoration(
        color: Colors.purpleAccent.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IgnorePointer(
        child: RCalendarWidget(
          controller: controller,
          customWidget: DefaultRCalendarCustomWidget(),
          firstDate: DateTime(2021, 7, 6),
          lastDate: DateTime(2055, 12, 31),
        ),
      ),
    );
  }
}
