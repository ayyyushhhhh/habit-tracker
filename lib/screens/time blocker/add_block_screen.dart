import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_table/hive%20boxes/task_boxes.dart';
import 'package:time_table/models/time_blocker/time_block_model.dart';

enum TimeType { StartTime, EndTime }

class AddBlockScreen extends StatefulWidget {
  const AddBlockScreen({Key? key}) : super(key: key);

  @override
  _AddBlockScreenState createState() => _AddBlockScreenState();
}

class _AddBlockScreenState extends State<AddBlockScreen> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String? taskTitle;
  String? taskDescription;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
  }

  void _saveTask() {
    print("out");
    print(taskTitle);
    print(taskDescription);
    if (taskTitle != null && taskDescription != null) {
      print("hey");
      List<TimeBlockModel> listTasks = [];
      final TimeBlockModel task = TimeBlockModel(
          from: _startTime,
          to: _endTime,
          taskTitle: taskTitle.toString(),
          taskDescription: taskDescription.toString());
      final taskDate = DateFormat.yMd().format(selectedDate);
      final taskBox = TaskBox.getTaskBox();
      if (taskBox.get(taskDate) != null) {
        listTasks = taskBox.get(taskDate)!;
        listTasks.add(task);
      } else {
        listTasks = [task];
      }
      taskBox.put(taskDate, listTasks);
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
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker({required BuildContext context}) {
    String date = DateFormat.yMMMMd('en_US').format(selectedDate);

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
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Text(
                    date,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020, 12, 10),
                          lastDate: DateTime(2025, 12, 10))
                      .then((date) => setState(() {
                            selectedDate = date as DateTime;
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
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime:
            selectTimetype == TimeType.StartTime ? _startTime : _endTime,
        confirmText: "Done",
        cancelText: "Cancel") as TimeOfDay;

    setState(() {
      if (selectTimetype == TimeType.StartTime) {
        _startTime = picked;
      } else if (selectTimetype == TimeType.EndTime) {
        _endTime = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 34,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Title",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  taskTitle = value;
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  taskDescription = value;
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
                      style: TextStyle(fontSize: 24),
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
