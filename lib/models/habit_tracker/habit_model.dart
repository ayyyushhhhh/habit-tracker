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

  Habit(
      {required this.title,
      required this.icon,
      this.isDone = false,
      this.completedDates,
      this.skipDates,
      required this.description});

  Habit updateWith(
      {bool? isCompleted, DateTime? completeDate, DateTime? skipDate}) {
    if (completeDate != null) {
      completedDates!.add(completeDate);
    }
    if (skipDate != null) {
      skipDates!.add(skipDate);
    }

    return Habit(
        title: title,
        icon: icon,
        description: description,
        completedDates: completedDates,
        skipDates: skipDates,
        isDone: isCompleted ?? isDone);
  }
}
