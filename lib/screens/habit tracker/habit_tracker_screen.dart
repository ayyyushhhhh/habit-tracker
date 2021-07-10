import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:time_table/Widgets/habit%20tracker/add_habit_card.dart';
import 'package:time_table/Widgets/habit%20tracker/completed_habit_card.dart';
import 'package:time_table/Widgets/habit%20tracker/habit_card.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';
import 'package:time_table/screens/habit%20tracker/add_habit_screen.dart';
import 'package:time_table/screens/habit%20tracker/habit_summary_screen.dart';
import 'package:time_table/utils/habit%20tracker/habit_tracker_colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_table/utils/habit%20tracker/prefrences.dart';
import 'package:time_table/utils/habit%20tracker/theme_provider.dart';

class HabitTrackerScreen extends StatefulWidget {
  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  double? deviceHeight;

  double? devicewidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  Habit calculateStreak({
    required Habit habit,
  }) {
    int index = habit.index!;
    int lastIndex = habit.lastIndex!;
    int streaks = habit.streaks!;
    List<DateTime> totalDates = habit.completedDates! + habit.skipDates!;
    totalDates.sort();
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
    final habitbox = HabitBox.getHabitBox();
    habitbox.put(habit.title,
        habit.updateWith(streak: streaks, lastIndex: lastIndex, index: index));
    return habit.updateWith(
        streak: streaks, lastIndex: lastIndex, index: index);
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    devicewidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _headWidget(),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Let's make a Habit Today",
                  style: TextStyle(
                      fontSize: devicewidth! / 15,
                      fontWeight: FontWeight.w500,
                      color: kHeadingTextColor),
                ),
              ),
              ValueListenableBuilder<Box<Habit>>(
                builder: (BuildContext context, box, Widget? child) {
                  final habits = box.values.toList().cast<Habit>();
                  return Container(
                    height: deviceHeight! / 3,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: habits.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == habits.length) {
                          return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return AddHabitScreen();
                                  }),
                                );
                              },
                              child: InkWell(child: AddHabitcard()));
                        }
                        return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return HabitSummaryScreen(
                                      habit: calculateStreak(
                                          habit: habits[index]));
                                }),
                              );
                            },
                            child: HabitCard(habit: habits[index]));
                      },
                    ),
                  );
                },
                valueListenable: HabitBox.getHabitBox().listenable(),
              ),
              SizedBox(
                height: 20,
              ),
              _progressContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressContainer() {
    return Container(
        margin: EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Progress",
              style: TextStyle(
                  fontSize: 34,
                  color: Colors.purpleAccent.shade100,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            ValueListenableBuilder<Box<Habit>>(
              builder: (BuildContext context, box, Widget? child) {
                final habits = box.values.toList().cast<Habit>();
                habits.retainWhere((habit) {
                  if (habit.isDone == true) {
                    return true;
                  } else {
                    return false;
                  }
                });
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: habits.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CompletedHabitCard(
                      completedHabit: habits[index],
                    );
                  },
                );
              },
              valueListenable: HabitBox.getHabitBox().listenable(),
            ),
          ],
        ));
  }

  Align _headWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: devicewidth! / 1.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello ,",
                    style: TextStyle(
                      fontSize: devicewidth! / 12,
                      color: kHeadingTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Prefrences.getuserName(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: devicewidth! / 12,
                      color: Colors.purpleAccent.shade100,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Consumer<ThemeManager>(
                builder: (BuildContext context, theme, Widget? child) {
              return Row(
                children: [
                  Icon(Prefrences.getSavedTheme() == 0
                      ? Icons.dark_mode
                      : Icons.light_mode),
                  CupertinoSwitch(
                    value: Prefrences.getSavedTheme() == 0 ? true : false,
                    onChanged: (value) {
                      Prefrences.saveTheme(value ? 1 : 0);
                      if (value == false) {
                        theme.updateTheme(ThemeType.LightTheme);
                      } else {
                        theme.updateTheme(ThemeType.DarkTheme);
                      }
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
