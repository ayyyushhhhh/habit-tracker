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
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();

    _setCalendarMarker();
    _calculateStats();
  }

  void _calculateStats() {
    final DateTime createdDate = DateTime(
      widget.habit.dateCreated!.year,
      widget.habit.dateCreated!.month,
      widget.habit.dateCreated!.day,
    );

    final DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    diffDate = now.difference(createdDate).inDays + 1;
    completeionPecent = (widget.habit.completedDates!.length) / diffDate * 100;
  }

  void _setCalendarMarker() {
    for (final date in widget.habit.completedDates!) {
      selectedEvents[date] = ["Completed"];
    }
    for (final date in widget.habit.skipDates!) {
      selectedEvents[date] = ["Skiped"];
    }
  }

  List<String> _getCompletedEvents(DateTime date) {
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
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              flexibleSpace: const FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  "Habit Summary",
                  style: TextStyle(
                    // fontSize: deviceWidth / 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _deleteHabitBuilder(context);
                  },
                  icon: const Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {
                    _shareScreenshot(_screenshotController);
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: const EdgeInsets.only(
                      right: 20,
                      left: 20,
                      bottom: 20,
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          widget.habit.icon,
                          height: deviceHeight / 5,
                          width: deviceHeight / 5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.habit.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: TextStyle(
                            fontSize: deviceWidth / 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.purpleAccent.shade100,
                          ),
                        ),
                        Text(
                          widget.habit.description,
                          maxLines: 5,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: deviceWidth / 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "It takes 21 Days to create Habit.",
                                style: TextStyle(
                                  fontSize: deviceWidth / 15,
                                  fontWeight: FontWeight.w800,
                                  color: kHeadingTextColor,
                                ),
                              ),
                              const SizedBox(
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
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: deviceWidth,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF03C8FE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Since, ${DateFormat.yMMMMd('en_US').format(widget.habit.dateCreated!)}",
                                  style: TextStyle(
                                    fontSize: deviceWidth / 15,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                headColor: Colors.green.shade900,
                              ),
                              _buildDataRow(
                                head: 'Skiped Days',
                                data: widget.habit.skipDates!.length,
                                headColor: Colors.red.shade900,
                              ),
                              _buildDataRow(
                                head: 'Completion Percentage',
                                data:
                                    "${completeionPecent.toStringAsFixed(2)} %",
                                headColor: Colors.amberAccent,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    completeionPecent < 30
                                        ? "You are a warrior fight back for the right track."
                                        : "Persitence is the key, You are on the right track.",
                                    style: TextStyle(
                                      fontSize: deviceWidth / 20,
                                      fontWeight: FontWeight.w700,
                                      color: completeionPecent < 30
                                          ? Colors.redAccent
                                          : Colors.lightGreenAccent,
                                    ),
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
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            head,
            style: TextStyle(
              fontSize: deviceWidth / 20,
              fontWeight: FontWeight.w600,
              color: headColor,
            ),
          ),
          Text(
            data.toString(),
            style: TextStyle(
              fontSize: deviceWidth / 20,
              fontWeight: FontWeight.w500,
              color: headColor,
            ),
          ),
        ],
      ),
    );
  }

  Container calendarMarkers() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "--- Habit Complete Dates",
                style: TextStyle(
                  fontSize: deviceWidth / 20,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "--- Habit Skip Dates",
                style: TextStyle(
                  fontSize: deviceWidth / 20,
                  color: Colors.redAccent,
                ),
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
        title: const Text("Delete Habit"),
        content: const Text("Do You want To Delete this habit? "),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              habitbox.delete(widget.habit.title);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
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
      firstDay: DateTime.utc(2021),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      eventLoader: (day) {
        return _getCompletedEvents(day);
      },
      headerStyle:
          const HeaderStyle(formatButtonVisible: false, titleCentered: true),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (widget.habit.completedDates!
              .contains(DateTime(date.year, date.month, date.day))) {
            return Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            );
          } else if (widget.habit.skipDates!
              .contains(DateTime(date.year, date.month, date.day))) {
            return Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _shareScreenshot(ScreenshotController controller) async {
    final imageBytes = await controller.captureFromWidget(_screenshotWidet());
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/screenshot${DateTime.now()}.png');
    image.writeAsBytesSync(imageBytes);
    const String appURl =
        "https://play.google.com/store/apps/details?id=com.scarecrowhouse.activity_tracker";
    await Share.shareFiles(
      [image.path],
      text:
          "Track and grow is helping me in building this habit. Download Track and grow - $appURl ",
    );
  }

  Widget _screenshotWidet() {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(10),
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
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    "I'm on ${widget.habit.streaks} day(s) streaks🔥 to create ${widget.habit.title} habit.",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Here's my journey so far",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.purpleAccent.shade100,
              ),
              child: _buildHabitCalendar(),
            ),
          ],
        ),
      ),
    );
  }
}
