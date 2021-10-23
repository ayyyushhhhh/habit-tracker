import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_table/models/time_blocker/time_block_model.dart';
import 'package:time_table/utils/time%20block/time_block_prefrences.dart';

class TimeBlockCard extends StatefulWidget {
  final Tasks blockTask;
  const TimeBlockCard({
    required this.blockTask,
    required this.selectedDate,
    required this.index,
  });
  final String selectedDate;
  final int index;
  @override
  _TimeBlockCardState createState() => _TimeBlockCardState();
}

class _TimeBlockCardState extends State<TimeBlockCard> {
  Color cardColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    if (widget.blockTask.isDone == true) {
      cardColor = const Color(0xFF00F6CE);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onDoubleTap: () {
        setState(() {
          _updateTask(context);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            SizedBox(
              width: _deviceWidth / 6,
              height: _deviceHeight / 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.blockTask.from,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Text("----"),
                  Text(
                    widget.blockTask.to,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: _deviceHeight / 5,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.blockTask.taskTitle,
                      style: TextStyle(
                        fontSize: _deviceWidth / 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.blockTask.from,
                          style: const TextStyle(color: Colors.black),
                        ),
                        const Text(
                          " - ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          widget.blockTask.to,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Text(
                        widget.blockTask.taskDescription,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: _deviceWidth / 30,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.1,
                        ),
                      ),
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
      cardColor = const Color(0xFF00F6CE);
      final Tasks task = Tasks(
        from: widget.blockTask.from,
        to: widget.blockTask.to,
        taskTitle: widget.blockTask.taskTitle,
        taskDescription: widget.blockTask.taskDescription,
        isDone: true,
      );
      final taskString = jsonEncode(task);
      final taskNotifier = Provider.of<TasksNotifier>(context, listen: false);
      final taskList = TasksData.getSavedTask(widget.selectedDate);
      taskList[widget.index] = taskString;
      taskNotifier.saveTasksList(widget.selectedDate, taskList);
    }
  }
}
