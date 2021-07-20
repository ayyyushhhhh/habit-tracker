import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'time_block_model.g.dart';

@HiveType(typeId: 1)
class TimeBlockModel {
  @HiveField(0)
  TimeOfDay from;
  @HiveField(1)
  TimeOfDay to;
  @HiveField(2)
  String taskTitle;
  @HiveField(3)
  String taskDescription;
  TimeBlockModel(
      {required this.from,
      required this.to,
      required this.taskTitle,
      required this.taskDescription});
}
