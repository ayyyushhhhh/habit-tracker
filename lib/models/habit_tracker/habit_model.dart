// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
part 'habit_model.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String icon;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  String description;

  @HiveField(4)
  List<DateTime>? completedDates;

  @HiveField(5)
  List<DateTime>? skipDates;

  @HiveField(6)
  int? index;

  @HiveField(7)
  int? lastIndex;

  @HiveField(8)
  int? streaks;

  @HiveField(9)
  DateTime? dateCreated;

  Habit({
    required this.title,
    required this.icon,
    this.isDone = false,
    this.completedDates,
    this.skipDates,
    this.index,
    this.lastIndex,
    this.streaks,
    this.dateCreated,
    required this.description,
  });

  Habit updateWith({
    bool? isCompleted,
    DateTime? completeDate,
    DateTime? skipDate,
    int? streak,
    int? index,
    int? lastIndex,
  }) {
    if (completeDate != null) {
      completedDates!.add(completeDate);
    }
    if (skipDate != null) {
      skipDates!.add(skipDate);
    }

    return Habit(
      title: this.title,
      icon: this.icon,
      description: this.description,
      completedDates: completedDates,
      skipDates: skipDates,
      isDone: isCompleted ?? this.isDone,
      streaks: streak ?? this.streaks,
      index: index ?? this.index,
      lastIndex: lastIndex ?? this.lastIndex,
      dateCreated: this.dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    final completedDatesMap = json
        .encode(this.completedDates!.map((date) => date.toString()).toList());
    final skipDatesMap =
        json.encode(this.skipDates!.map((date) => date.toString()).toList());
    return {
      'title': this.title,
      'icon': this.icon,
      'isDone': this.isDone,
      'description': this.description,
      'completedDates': completedDatesMap,
      'skipDates': skipDatesMap,
      'dateCreated': this.dateCreated.toString(),
      'streaks': this.streaks,
      'lastIndex': this.lastIndex,
      'index': this.index,
    };
  }

  // ignore: prefer_constructors_over_static_methods
  static Habit fromMap(Map<String, dynamic> map) {
    final compDates = jsonDecode(map['completedDates'] as String);
    final skipDates = jsonDecode(map['skipDates'] as String);
    final List<DateTime> compDatesList = [];
    for (final compDate in compDates) {
      compDatesList
          .add(DateFormat("yyyy-MM-dd hh:mm:ss").parse(compDate as String));
    }
    final List<DateTime> skipDatesList = [];
    for (final skipDate in skipDates) {
      skipDatesList
          .add(DateFormat("yyyy-MM-dd hh:mm:ss").parse(skipDate as String));
    }
    final lastDate = DateTime(
      compDatesList.last.year,
      compDatesList.last.month,
      compDatesList.last.day,
    );
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (lastDate != now) {
      map["isDone"] = false;
    }

    final Habit habit = Habit(
      title: map['title'] as String,
      icon: map['icon'] as String,
      isDone: map['isDone'] as bool,
      description: map['description'] as String,
      dateCreated:
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(map["dateCreated"] as String),
      completedDates: compDatesList,
      skipDates: skipDatesList,
      streaks: map['streaks'] as int,
      lastIndex: map['lastIndex'] as int,
      index: map['index'] as int,
    );
    return habit;
  }
}
