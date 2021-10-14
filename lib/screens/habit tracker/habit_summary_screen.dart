import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
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
  late double deviceHeight;
  late double deviceWidth;
  int diffDate = 0;
  double completeionPecent = 0.0;
  ScreenshotController _screenshotController = ScreenshotController();

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
    completeionPecent =
        ((widget.habit.completedDates!.length) / diffDate * 100);
  }

  List<String> _getCompletedEvents(DateTime date) {
    date = DateTime(date.year, date.month, date.day);
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: deviceHeight / 8,
              pinned: true,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  "Habit Summary",
                  style: TextStyle(
                      // fontSize: deviceWidth / 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _deleteHabitBuilder(context);
                  },
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {
                    _shareScreenshot(_screenshotController);
                  },
                  icon: Icon(Icons.share),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: EdgeInsets.only(
                        right: 20, left: 20, bottom: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          widget.habit.icon,
                          height: deviceHeight / 5,
                          width: deviceHeight / 5,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.habit.title,
                          style: TextStyle(
                              fontSize: deviceWidth / 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.purpleAccent.shade100),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "It takes 21 Days to create Habit.",
                                style: TextStyle(
                                    fontSize: deviceWidth / 15,
                                    fontWeight: FontWeight.w800,
                                    color: kHeadingTextColor),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "You are on ${widget.habit.streaks} day(s) streak to create a habit.",
                                style: TextStyle(
                                  fontSize: deviceWidth / 15,
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
                            color: Color(0xFF03C8FE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Since, ${DateFormat.yMMMMd('en_US').format(widget.habit.dateCreated!)}",
                                  style: TextStyle(
                                      fontSize: deviceWidth / 15,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              _buildDataRow(
                                head: 'Total Days',
                                data: diffDate,
                                headColor: Colors.blueAccent.shade700,
                              ),
                              _buildDataRow(
                                  head: 'Completed Days',
                                  data: widget.habit.completedDates!.length,
                                  headColor: Colors.green.shade900),
                              _buildDataRow(
                                  head: 'Skiped Days',
                                  data: widget.habit.skipDates!.length,
                                  headColor: Colors.red.shade900),
                              _buildDataRow(
                                  head: 'Completion Percentage',
                                  data:
                                      "${completeionPecent.toStringAsFixed(2)} %",
                                  headColor: Colors.amberAccent),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    completeionPecent < 30
                                        ? "You are a warrior fight back for the right track."
                                        : "Persitence is the key, You are on the right track.",
                                    style: TextStyle(
                                        fontSize: deviceWidth / 20,
                                        fontWeight: FontWeight.w700,
                                        color: completeionPecent < 30
                                            ? Colors.redAccent
                                            : Colors.lightGreenAccent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildDataRow({
    required String head,
    required dynamic data,
    required Color headColor,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            head,
            style: TextStyle(
                fontSize: deviceWidth / 20,
                fontWeight: FontWeight.w600,
                color: headColor),
          ),
          Text(
            data.toString(),
            style: TextStyle(
                fontSize: deviceWidth / 20,
                fontWeight: FontWeight.w500,
                color: headColor),
          ),
        ],
      ),
    );
  }

  Container calendarMarkers() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.green),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "--- Habit Complete Dates",
                  style: TextStyle(
                      fontSize: deviceWidth / 20, color: Colors.green),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
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
                  style: TextStyle(
                      fontSize: deviceWidth / 20, color: Colors.redAccent),
                ),
              ],
            ),
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

  void _shareScreenshot(ScreenshotController controller) async {
    final imageBytes = await controller.captureFromWidget(_screenshotWidet());
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/screenshot${DateTime.now()}.png');
    image.writeAsBytesSync(imageBytes);
    String appURl =
        "https://play.google.com/store/apps/details?id=com.scarecrowhouse.activity_tracker";
    await Share.shareFiles([image.path],
        text:
            "Track and grow is helping me in building this habit. Download Track and grow - $appURl ");
  }

  Widget _screenshotWidet() {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  widget.habit.icon,
                  height: deviceHeight / 7,
                  width: deviceHeight / 7,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      "I'm on ${widget.habit.streaks} day(s) streaks🔥 to create ${widget.habit.title} habit.",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Here's my journey so far",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purpleAccent.shade100),
                child: _buildHabitCalendar()),
          ],
        ),
      ),
    );
  }
}
