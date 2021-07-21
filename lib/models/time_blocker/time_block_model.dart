import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_table/utils/time%20block/time_block_prefrences.dart';
import 'package:json_annotation/json_annotation.dart';
part 'time_block_model.g.dart';

@JsonSerializable()
class Tasks {
  final String from;
  final String to;

  final String taskTitle;

  final String taskDescription;
  Tasks(
      {required this.from,
      required this.to,
      required this.taskTitle,
      required this.taskDescription});

  factory Tasks.fromJson(Map<String, dynamic> json) => _$TasksFromJson(json);
  Map<String, dynamic> toJson() => _$TasksToJson(this);

  // Map<String, dynamic> toJson() {
  //   return {
  //     'from': this.from,
  //     'to': this.to,
  //     'taskTitle': this.taskTitle,
  //     'taskDescription': this.taskDescription,
  //   };
  // }

  // Tasks.fromJson(Map<String, dynamic> json)
  //     : from = json["from"],
  //       to = json["to"],
  //       taskTitle = json["taskTitle"],
  //       taskDescription = json["taskDescription"];
}

class TasksNotifier extends ChangeNotifier {
  List<String> tasksList = TasksData.getSavedTask(
    DateFormat.yMMMMd('en_US').format(
      DateTime.now(),
    ),
  );

  void updateTasksList(String date, List<String> tasks) {
    TasksData.saveTask(date, tasks);
    tasksList = TasksData.getSavedTask(date);
    notifyListeners();
  }
}
