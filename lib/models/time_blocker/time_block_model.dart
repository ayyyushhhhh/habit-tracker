import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
import 'package:time_table/utils/time%20block/time_block_prefrences.dart';
part 'time_block_model.g.dart';

@JsonSerializable()
class Tasks {
  final String from;
  final String to;
  final String taskTitle;
  final String taskDescription;
  bool isDone = false;
  Tasks({
    required this.from,
    required this.to,
    required this.taskTitle,
    required this.taskDescription,
    this.isDone = false,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) => _$TasksFromJson(json);
  Map<String, dynamic> toJson() => _$TasksToJson(this);
}

class TasksNotifier extends ChangeNotifier {
  void saveTasksList(String date, List<String> tasks) {
    TasksData.saveTask(date, tasks);
    notifyListeners();
  }

  void updateTasksList(String date) {
    notifyListeners();
  }
}
