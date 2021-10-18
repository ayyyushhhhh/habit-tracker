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

  Habit(
      {required this.title,
      required this.icon,
      this.isDone = false,
      this.completedDates,
      this.skipDates,
      this.index,
      this.lastIndex,
      this.streaks,
      this.dateCreated,
      required this.description});

  Habit updateWith(
      {bool? isCompleted,
      DateTime? completeDate,
      DateTime? skipDate,
      int? streak,
      int? index,
      int? lastIndex}) {
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
    var completedDatesMap = json
        .encode(this.completedDates!.map((date) => date.toString()).toList());
    var skipDatesMap =
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

  static Habit fromMap(Map<String, dynamic> map) {
    var compDates = jsonDecode(map['completedDates']);
    var skipDates = jsonDecode(map['skipDates']);
    List<DateTime> compDatesList = [];
    for (var compDate in compDates) {
      compDatesList.add(DateFormat("yyyy-MM-dd hh:mm:ss").parse(compDate));
    }
    List<DateTime> skipDatesList = [];
    for (var skipDate in skipDates) {
      skipDatesList.add(DateFormat("yyyy-MM-dd hh:mm:ss").parse(skipDate));
    }
    Habit habit = Habit(
      title: map['title'],
      icon: map['icon'],
      isDone: map['isDone'],
      description: map['description'],
      dateCreated: DateFormat("yyyy-MM-dd hh:mm:ss").parse(map["dateCreated"]),
      completedDates: compDatesList,
      skipDates: skipDatesList,
      streaks: map['streaks'],
      lastIndex: map['lastIndex'],
      index: map['index'],
    );
    return habit;
  }
}
