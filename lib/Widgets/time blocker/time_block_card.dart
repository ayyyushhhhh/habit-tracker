import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_table/models/time_blocker/time_block_model.dart';
import 'package:time_table/utils/time%20block/time_block_prefrences.dart';

class TimeBlockCard extends StatefulWidget {
  final Tasks blockTask;
  const TimeBlockCard(
      {Key? key,
      required this.blockTask,
      required this.selectedDate,
      required this.index});
  final String selectedDate;
  final int index;
  @override
  _TimeBlockCardState createState() => _TimeBlockCardState();
}

class _TimeBlockCardState extends State<TimeBlockCard> {
  Color cardColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    if (widget.blockTask.isDone == true) {
      cardColor = Colors.greenAccent;
    }
    return InkWell(
      onDoubleTap: () {
        setState(() {
          _updateTask(context);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 0),
              width: 100,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.blockTask.from,
                    style: TextStyle(fontSize: 12),
                  ),
                  Text("----"),
                  Text(
                    widget.blockTask.from,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.blockTask.taskTitle.toString(),
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.blockTask.from,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(" - ", style: TextStyle(color: Colors.black)),
                        Text(
                          widget.blockTask.to,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.blockTask.taskDescription.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTask(BuildContext context) {
    if (widget.blockTask.isDone == false) {
      cardColor = Colors.lightGreenAccent;
      Tasks task = Tasks(
          from: widget.blockTask.from,
          to: widget.blockTask.to,
          taskTitle: widget.blockTask.taskTitle,
          taskDescription: widget.blockTask.taskDescription,
          isDone: true);
      final taskString = jsonEncode(task);
      final taskNotifier = Provider.of<TasksNotifier>(context, listen: false);
      final taskList = TasksData.getSavedTask(widget.selectedDate);
      taskList[widget.index] = taskString;
      taskNotifier.saveTasksList(widget.selectedDate, taskList);
    }
  }
}
