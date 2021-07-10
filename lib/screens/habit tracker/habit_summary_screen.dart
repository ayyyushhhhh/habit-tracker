import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
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
  Map<DateTime, List<String>> selectedEvents = {};
  int diffDate = 0;
  double completeionPecent = 0.0;
  @override
  void initState() {
    super.initState();
    diffDate = DateTime.now().difference(widget.habit.dateCreated!).inDays + 1;
    widget.habit.completedDates!.forEach((date) {
      selectedEvents[date] = ["Completed"];
    });
    widget.habit.skipDates!.forEach((date) {
      selectedEvents[date] = ["Skiped"];
    });
    completeionPecent = (widget.habit.completedDates!.length) / diffDate * 100;
  }

  List<String> _getCompletedEvents(DateTime date) {
    date = DateTime(date.year, date.month, date.day);
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _deleteHabitBuilder(context);
            },
            icon: Icon(Icons.delete),
          ),
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
                height: deviceHeight / 10,
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "It takes 21 Days to create Habit.",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: kHeadingTextColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "You are on ${widget.habit.streaks} day(s) streak to create a habit.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              _habitCalendar(deviceHeight, deviceWidth),
              calendarMarkers(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: deviceWidth,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Since, ${DateFormat.yMMMMd('en_US').format(widget.habit.dateCreated!)}",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildDataRow(
                      head: 'Total Days',
                      data: diffDate,
                      headColor: Colors.blueAccent,
                    ),
                    _buildDataRow(
                        head: 'Completed Days',
                        data: widget.habit.completedDates!.length,
                        headColor: Colors.green),
                    _buildDataRow(
                        head: 'Skiped Days',
                        data: widget.habit.skipDates!.length,
                        headColor: Colors.red),
                    _buildDataRow(
                        head: 'Completion Percentage',
                        data: "$completeionPecent %",
                        headColor: Colors.amberAccent),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        completeionPecent < 30
                            ? "You are a warrior fight back for the right track"
                            : "Persitence is the key, You are on the right track",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: completeionPecent < 30
                                ? Colors.redAccent
                                : Colors.lightGreenAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildDataRow(
      {required String head, required dynamic data, required Color headColor}) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            head,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: headColor),
          ),
          Text(
            data.toString(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: headColor),
          ),
        ],
      ),
    );
  }

  Container calendarMarkers() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "--- Habit Complete Dates",
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "--- Habit Skip Dates",
                style: TextStyle(fontSize: 20, color: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteHabitBuilder(BuildContext context) {
    final habitbox = HabitBox.getHabitBox();
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: new Text("Delete Habit"),
        content: new Text("Do You want To Delete this habit? "),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              habitbox.delete(widget.habit.title);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Yes"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No"),
          ),
        ],
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
      child: _buildHabitCalendar(),
    );
  }

  TableCalendar<Object> _buildHabitCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2021, 01, 01),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      eventLoader: (day) {
        return _getCompletedEvents(day);
      },
      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
      calendarBuilders:
          CalendarBuilders(markerBuilder: (context, date, events) {
        if (widget.habit.completedDates!
            .contains(DateTime(date.year, date.month, date.day))) {
          return Container(
            height: 10,
            width: 10,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          );
        } else if (widget.habit.skipDates!
            .contains(DateTime(date.year, date.month, date.day))) {
          return Container(
            height: 10,
            width: 10,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          );
        }
      }),
    );
  }
}
