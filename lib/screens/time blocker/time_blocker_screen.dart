import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_table/Widgets/time%20blocker/time_block_card.dart';
import 'package:time_table/models/time_blocker/time_block_model.dart';
import 'package:time_table/screens/time%20blocker/add_block_screen.dart';
import 'package:time_table/utils/time%20block/time_block_prefrences.dart';

class TimeBlockerScreen extends StatefulWidget {
  @override
  _TimeBlockerScreenState createState() => _TimeBlockerScreenState();
}

class _TimeBlockerScreenState extends State<TimeBlockerScreen> {
  DateTime _selectedDate = DateTime.now();
  double _deviceHeight = 0;
  double _deviceWidth = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Text(
                      "Let's Plan \nYour Day",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _deviceWidth / 12,
                        color: Colors.teal.shade300,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const AddBlockScreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: _deviceHeight / 20,
                      width: _deviceWidth / 4,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Add Task",
                          style: TextStyle(
                            fontSize: _deviceWidth / 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _buildCalendar(),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Consumer<TasksNotifier>(
                  builder: (BuildContext context, value, Widget? child) {
                    final List<String> tasks = TasksData.getSavedTask(
                      DateFormat.yMMMMd("en_US").format(_selectedDate),
                    );

                    final List<Tasks> decodedTasks = [];
                    for (final task in tasks) {
                      decodedTasks.add(
                        Tasks.fromJson(
                          json.decode(task) as Map<String, dynamic>,
                        ),
                      );
                    }
                    decodedTasks.sort((a, b) {
                      if (a.from.contains("m")) {
                        final format = DateFormat.jm();
                        final TimeOfDay afromTime =
                            TimeOfDay.fromDateTime(format.parse(a.from));
                        final TimeOfDay bfromTime =
                            TimeOfDay.fromDateTime(format.parse(b.from));
                        final double aTime =
                            afromTime.hour + afromTime.minute / 60.0;
                        final double bTime =
                            bfromTime.hour + bfromTime.minute / 60.0;
                        return aTime.compareTo(bTime);
                      } else {
                        return a.from.compareTo(b.from);
                      }
                    });
                    if (decodedTasks.isEmpty) {
                      return const Center(
                        child: Text("No Work Today"),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: decodedTasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              _removeTask(context, index);
                            },
                            child: TimeBlockCard(
                              blockTask: decodedTasks[index],
                              index: index,
                              selectedDate: DateFormat.yMMMMd("en_US")
                                  .format(_selectedDate),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeTask(BuildContext context, int index) {
    final taskNotifier = Provider.of<TasksNotifier>(context, listen: false);
    final taskList = TasksData.getSavedTask(
      DateFormat.yMMMMd("en_US").format(_selectedDate),
    );
    taskList.removeAt(index);
    taskNotifier.saveTasksList(
      DateFormat.yMMMMd("en_US").format(_selectedDate),
      taskList,
    );
  }

  TableCalendar _buildCalendar() {
    return TableCalendar(
      rowHeight: 80,
      headerStyle:
          const HeaderStyle(formatButtonVisible: false, titleCentered: true),
      calendarFormat: CalendarFormat.week,
      focusedDay: DateTime.now(),
      firstDay: DateTime(2019, 06, 13),
      lastDay: DateTime(2031, 12, 31),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDate, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          final tasksProv = Provider.of<TasksNotifier>(context, listen: false);
          _selectedDate = selectedDay;
          tasksProv.updateTasksList(
            DateFormat.yMMMd("en_us").format(_selectedDate),
          );
        });
      },
      calendarBuilders: CalendarBuilders(
        todayBuilder: (context, dateTime, datetime) {
          return Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.teal),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat.E().format(datetime),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    DateFormat.d().format(datetime),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        defaultBuilder: (context, dateTime, date) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.E().format(dateTime),
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  DateFormat.d().format(dateTime),
                  style: TextStyle(
                    //color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFFF4D98),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat.E().format(day),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _deviceWidth / 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat.d().format(day),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _deviceWidth / 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        dowBuilder: (context, day) {
          return const Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
