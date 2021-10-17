import 'package:hive/hive.dart';
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
    return {
      'title': this.title,
      'icon': this.icon,
      'isDone': this.isDone,
      'description': this.description,
      'completedDates': this.completedDates,
      'skipDates': this.skipDates,
      'dateCreated': this.dateCreated,
      'streaks': this.streaks,
      'lastIndex': this.lastIndex,
    };
  }

  Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      title: map['title'],
      icon: map['icon'],
      isDone: map['isDone'],
      description: map['isDone'],
      completedDates: map['completedDates'],
      skipDates: map['skipDates'],
      dateCreated: map['dateCreated'],
      streaks: map['streaks'],
      lastIndex: map['lastIndex'],
    );
  }
}
