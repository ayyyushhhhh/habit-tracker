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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'Let\'s Start by  \nPlanning Your Day ',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return AddBlockScreen();
                      }));
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Add Task",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _buildCalendar(),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Consumer<TasksNotifier>(
                  builder: (BuildContext context, value, Widget? child) {
                    List<String> tasks = value.tasksList;
                    tasks = TasksData.getSavedTask(
                        DateFormat.yMMMMd('en_US').format(
                      _selectedDate,
                    ));

                    if (tasks.isEmpty) {
                      return Center(
                        child: Text("No Work Today"),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          Tasks task =
                              Tasks.fromJson(json.decode(tasks[index]));
                          return TimeBlockCard(blockTask: task);
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

  Container _buildCalendar() {
    return Container(
      child: TableCalendar(
        headerStyle:
            HeaderStyle(formatButtonVisible: false, titleCentered: true),
        calendarFormat: CalendarFormat.week,
        focusedDay: DateTime.now(),
        firstDay: DateTime(2019, 06, 13),
        lastDay: DateTime(2022, 12, 31),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDate = selectedDay;
          });
        },
        calendarBuilders: CalendarBuilders(
          todayBuilder: (context, dateTime, datetime) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.purple.shade100,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.E().format(datetime),
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat.d().format(datetime),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
          defaultBuilder: (context, dateTime, date) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.E().format(dateTime),
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      DateFormat.d().format(dateTime),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
          dowBuilder: (context, day) {
            // final text = DateFormat.E().format(day);
            return Center(
              child: Text(
                "",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }
}
