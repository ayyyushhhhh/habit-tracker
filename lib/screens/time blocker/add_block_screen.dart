import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_table/Notification%20Manager/notification_manager.dart';
import 'package:time_table/models/time_blocker/time_block_model.dart';
import 'package:time_table/utils/time%20block/time_block_prefrences.dart';

enum TimeType { startTime, endTime }

// ignore: must_be_immutable
class AddBlockScreen extends StatefulWidget {
  const AddBlockScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AddBlockScreenState createState() => _AddBlockScreenState();
}

class _AddBlockScreenState extends State<AddBlockScreen> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String _taskTitle = "";
  String _taskDescription = "";
  DateTime _selectedDate = DateTime.now();
  double _deviceHeight = 0;
  double _deviceWidth = 0;

  @override
  void initState() {
    super.initState();
    _startTime = TimeOfDay.now();
    _endTime =
        TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
  }

  void _saveTask(BuildContext context) {
    if (_taskTitle.trimRight().isNotEmpty &&
        _taskDescription.trimRight().isNotEmpty) {
      final List<String> taskLists = TasksData.getSavedTask(
        DateFormat.yMMMMd('en_US').format(_selectedDate),
      );
      final Tasks task = Tasks(
        from: _startTime.format(context),
        to: _endTime.format(context),
        taskTitle: _taskTitle,
        taskDescription: _taskDescription,
      );
      final taskString = jsonEncode(task);
      taskLists.add(taskString);

      final taskNotifier = Provider.of<TasksNotifier>(context, listen: false);
      taskNotifier.saveTasksList(
        DateFormat.yMMMMd('en_US').format(_selectedDate),
        taskLists,
      );

      _sendNotification(task);

      _showSnackbar(
        context,
        "Double tap the card when you are done! or swipe the card to delete",
        "ok!",
      );
      Navigator.pop(context);
    } else if (_taskTitle.trimRight().isEmpty) {
      _showSnackbar(context, "Give some title", "ok!");
    } else if (_taskDescription.trimRight().isEmpty) {
      _showSnackbar(context, "Give some description", "ok!");
    }
  }

  void _sendNotification(Tasks task) {
    final DateTime notficationDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    if (notficationDate.isAfter(DateTime.now())) {
      NotificationManger.showScheduleNotification(
        id: task.taskTitle.length,
        title: "It's time for ${task.taskTitle}",
        body: "Remember to ${task.taskDescription}",
        scheduledDate: notficationDate,
      );
    }
  }

  void _showSnackbar(BuildContext context, String title, String label) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(title),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: label,
        onPressed: () {
          // Navigator.pop(context);
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildTimePicker({
    required String title,
    required TimeType timeType,
    required BuildContext context,
  }) {
    String time = "";
    if (timeType == TimeType.startTime) {
      time = _startTime.format(context);
    } else {
      time = _endTime.format(context);
    }

    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: _deviceWidth / 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                _showTimePicker(timeType, context);
              },
              child: Text(
                time,
                style: TextStyle(fontSize: _deviceWidth / 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker({required BuildContext context}) {
    final String date = DateFormat.yMMMMd('en_US').format(_selectedDate);

    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020, 12, 10),
          lastDate: DateTime(2025, 12, 10),
        );

        if (pickedDate != null) {
          _selectedDate = pickedDate;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date",
                  style: TextStyle(
                    fontSize: _deviceWidth / 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  date,
                  style: TextStyle(fontSize: _deviceHeight / 25),
                ),
              ],
            ),
            Icon(
              Icons.calendar_today,
              size: _deviceWidth / 16,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker(
    TimeType selectTimetype,
    BuildContext context,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectTimetype == TimeType.startTime ? _startTime : _endTime,
      confirmText: "Done",
      cancelText: "Cancel",
    );
    if (picked != null) {
      setState(
        () {
          if (selectTimetype == TimeType.startTime) {
            _startTime = picked;
          } else if (selectTimetype == TimeType.endTime) {
            _endTime = picked;
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: _deviceHeight / 8,
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
                  "Add a Task",
                  style: TextStyle(
                    // fontSize: deviceWidth / 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: TextStyle(
                          fontSize: _deviceWidth / 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _taskTitle = value;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          fillColor: Colors.black12,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Enter Task title ",
                        ),
                        maxLength: 20,
                      ),
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: _deviceWidth / 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _taskDescription = value;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          fillColor: Colors.black12,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Enter Task description",
                        ),
                        maxLines: 3,
                        maxLength: 100,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildDatePicker(context: context),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTimePicker(
                            title: "Start Time",
                            timeType: TimeType.startTime,
                            context: context,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          _buildTimePicker(
                            title: "End Time",
                            timeType: TimeType.endTime,
                            context: context,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          _saveTask(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.teal,
                          ),
                          child: Center(
                            child: Text(
                              "Add Task",
                              style: TextStyle(fontSize: _deviceWidth / 10),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
