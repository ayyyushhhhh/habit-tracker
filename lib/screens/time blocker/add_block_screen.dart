import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_table/models/time_blocker/time_block_model.dart';
import 'package:time_table/utils/time%20block/time_block_prefrences.dart';

enum TimeType { StartTime, EndTime }

class AddBlockScreen extends StatefulWidget {
  const AddBlockScreen({Key? key}) : super(key: key);

  @override
  _AddBlockScreenState createState() => _AddBlockScreenState();
}

class _AddBlockScreenState extends State<AddBlockScreen> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String? _taskTitle;
  String? _taskDescription;
  DateTime _selectedDate = DateTime.now();
  double _deviceHeight = 0;
  double _deviceWidth = 0;
  @override
  void initState() {
    super.initState();
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
  }

  void _saveTask() {
    if (_taskTitle != null && _taskDescription != null) {
      List<String> taskLists = TasksData.getSavedTask(
          DateFormat.yMMMMd('en_US').format(_selectedDate));
      Tasks task = Tasks(
          from: _startTime.format(context),
          to: _endTime.format(context),
          taskTitle: _taskTitle.toString(),
          taskDescription: _taskDescription.toString());
      final taskString = jsonEncode(task);

      taskLists.add(taskString);
      final taskNotifier = Provider.of<TasksNotifier>(context, listen: false);
      taskNotifier.saveTasksList(
          DateFormat.yMMMMd('en_US').format(_selectedDate), taskLists);
      Navigator.pop(context);
    }
  }

  Widget _buildTimePicker(
      {required String title,
      required TimeType timeType,
      required BuildContext context}) {
    String time = "";
    if (timeType == TimeType.StartTime) {
      time = _startTime.format(context);
    } else {
      time = _endTime.format(context);
    }

    return Flexible(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.teal, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: _deviceWidth / 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 24,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                _showTimePicker(timeType, context);
              },
              child: Container(
                child: Text(
                  time,
                  style: TextStyle(fontSize: _deviceWidth / 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker({required BuildContext context}) {
    String date = DateFormat.yMMMMd('en_US').format(_selectedDate);

    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.teal, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date",
                  style: TextStyle(
                      fontSize: _deviceWidth / 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Text(
                    date,
                    style: TextStyle(fontSize: _deviceHeight / 18),
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020, 12, 10),
                          lastDate: DateTime(2025, 12, 10))
                      .then((date) => setState(() {
                            if (date != null) {
                              _selectedDate = date;
                            }
                          }));
                },
                icon: Icon(
                  Icons.calendar_today,
                  size: 40,
                )),
          ],
        ));
  }

  _showTimePicker(TimeType selectTimetype, BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime:
            selectTimetype == TimeType.StartTime ? _startTime : _endTime,
        confirmText: "Done",
        cancelText: "Cancel");
    if (picked != null) {
      setState(() {
        if (selectTimetype == TimeType.StartTime) {
          _startTime = picked;
        } else if (selectTimetype == TimeType.EndTime) {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              Container(
                child: Text(
                  'Add a Task',
                  style: TextStyle(
                      fontSize: _deviceWidth / 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Title",
                style: TextStyle(
                    fontSize: _deviceWidth / 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  _taskTitle = value;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    hintText: "Enter Task title "),
                maxLength: 20,
              ),
              Text(
                "Description",
                style: TextStyle(
                    fontSize: _deviceWidth / 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  _taskDescription = value;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    hintText: "Enter Task description"),
                maxLines: 5,
              ),
              SizedBox(
                height: 10,
              ),
              _buildDatePicker(context: context),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimePicker(
                        title: "Start Time",
                        timeType: TimeType.StartTime,
                        context: context),
                    SizedBox(
                      width: 10,
                    ),
                    _buildTimePicker(
                        title: "End Time",
                        timeType: TimeType.EndTime,
                        context: context),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _saveTask();
                },
                child: Container(
                  padding: EdgeInsets.all(16),
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
      ),
    );
  }
}
