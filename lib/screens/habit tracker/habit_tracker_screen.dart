import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:time_table/Widgets/habit%20tracker/add_habit_card.dart';
import 'package:time_table/Widgets/habit%20tracker/completed_habit_card.dart';
import 'package:time_table/Widgets/habit%20tracker/habit_card.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';
import 'package:time_table/screens/habit%20tracker/add_habit_screen.dart';
import 'package:time_table/screens/habit%20tracker/habit_summary_screen.dart';
import 'package:time_table/utils/habit%20tracker/habit_tracker_colors.dart';
import 'package:time_table/utils/habit%20tracker/streak_cal.dart';
import 'package:time_table/utils/user_info.dart';

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
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  "Let's make a Habit Today",
                  style: TextStyle(
                    fontSize: devicewidth! / 15,
                    fontWeight: FontWeight.w500,
                    color: kHeadingTextColor,
                  ),
                ),
              ),
              ValueListenableBuilder<Box<Habit>>(
                builder: (BuildContext context, box, Widget? child) {
                  final habits = box.values.toList().cast<Habit>();
                  return SizedBox(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: habits.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == habits.length) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return AddHabitScreen();
                                  },
                                ),
                              );
                            },
                            child: GestureDetector(
                              child: AddHabitcard(),
                            ),
                          );
                        }
                        calculateStreak(habit: habits[index]);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return HabitSummaryScreen(
                                    habit: habits[index],
                                  );
                                },
                              ),
                            );
                          },
                          child: HabitCard(habit: habits[index]),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                      ),
                    ),
                  );
                },
                valueListenable: HabitBox.getHabitBox().listenable(),
              ),
              const SizedBox(
                height: 20,
              ),
              //_progressContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressContainer() {
    return Container(
      margin: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Progress",
            style: TextStyle(
              fontSize: 34,
              color: Colors.purpleAccent.shade100,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
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
      ),
    );
  }

  Align _headWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Consumer<User>(
          builder: (context, user, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
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
                        user.getName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: devicewidth! / 12,
                          color: kprimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    "assets/profilePictures/${user.getProfilePic}.png",
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
