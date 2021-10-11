import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';

Habit calculateStreak({
  required Habit habit,
}) {
  final habitbox = HabitBox.getHabitBox();

  int diff = DateTime.now().difference(habit.dateCreated!).inDays;

  for (int i = diff; i > 0; i--) {
    DateTime lastDate = DateTime.now().subtract(Duration(days: i));
    lastDate = DateTime(lastDate.year, lastDate.month, lastDate.day);
    if (!habit.skipDates!.contains(lastDate) &&
        !habit.completedDates!.contains(lastDate)) {
      habit = habit.updateWith(skipDate: lastDate);
    }
  }

  int index = habit.index!;
  int lastIndex = habit.lastIndex!;
  int streaks = habit.streaks!;
  List<DateTime> totalDates = habit.completedDates! + habit.skipDates!;
  totalDates.sort();

  if (totalDates.length != 0 && habit.skipDates!.contains(totalDates.last)) {
    streaks = 0;
  } else {
    for (int i = index; i < totalDates.length; i++) {
      if (habit.skipDates!.contains(totalDates[i])) {
        index = i;
        break;
      } else {
        index = totalDates.length;
      }
    }

    streaks = index - lastIndex;

    for (int i = index; i < totalDates.length; i++) {
      if (habit.completedDates!.contains(totalDates[i])) {
        lastIndex = i;
        break;
      }
    }

    index = lastIndex;
  }
  habitbox.put(habit.title,
      habit.updateWith(streak: streaks, lastIndex: lastIndex, index: index));
  return habit.updateWith(streak: streaks, lastIndex: lastIndex, index: index);
}
