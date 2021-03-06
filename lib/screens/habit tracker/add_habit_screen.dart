import 'package:flutter/material.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  String _habitIcon = "";
  String _habitTitle = "";
  String _description = "";
  String location = "assets/icons/";
  double deviceWidth = 0;

  void _saveHabit() {
    if (_habitTitle.trimRight().isNotEmpty &&
        _description.trimRight().isNotEmpty &&
        _habitIcon.isNotEmpty) {
      final Habit habit = Habit(
        title: _habitTitle,
        icon: _habitIcon,
        completedDates: [],
        skipDates: [],
        index: 0,
        lastIndex: 0,
        streaks: 0,
        dateCreated: DateTime.now(),
        description: _description,
      );
      final habitbox = HabitBox.getHabitBox();
      habitbox.put(_habitTitle, habit);

      Navigator.pop(context);
    } else if (_habitTitle.trimRight().isEmpty) {
      _showSnackbar(context, "Give some title", "ok!");
    } else if (_description.trimRight().isEmpty) {
      _showSnackbar(context, "Give some description", "ok!");
    } else if (_habitIcon.isEmpty) {
      _showSnackbar(context, "Select an icon", "ok!");
    }
  }

  void _showSnackbar(BuildContext context, String title, String label) {
    final snackBar = SnackBar(
      content: Text(title),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: label,
        onPressed: () {
          // Navigator.pop(context);
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: deviceHeight / 8,
              pinned: true,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              flexibleSpace: const FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  "Add Habit",
                  style: TextStyle(
                    // fontSize: deviceWidth / 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Habit Title",
                          style: TextStyle(
                            fontSize: deviceHeight / 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              _habitTitle = value;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Enter Habit title eg,Running",
                            ),
                            // maxLength: 20,
                          ),
                        ),
                        Text(
                          "Habit Description",
                          style: TextStyle(
                            fontSize: deviceHeight / 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              _description = value;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              hintText:
                                  "Add a little description eg, run 10 km ",
                            ),
                            // maxLength: 40,
                          ),
                        ),
                        Text(
                          "Choose an Icon",
                          style: TextStyle(
                            fontSize: deviceHeight / 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        iconsSelector(),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          child: Container(
                            height: deviceHeight / 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.purpleAccent.shade100,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _saveHabit();
                              },
                              child: Center(
                                child: Text(
                                  "Add Habit",
                                  style: TextStyle(
                                    fontSize: deviceHeight / 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container iconsSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconGenerator(icon: "${location}gmail.png"),
              _iconGenerator(icon: "${location}no-junk-food.png"),
              _iconGenerator(icon: "${location}fitness.png"),
              _iconGenerator(icon: "${location}yoga.png"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconGenerator(icon: "${location}water.png"),
              _iconGenerator(icon: "${location}running.png"),
              _iconGenerator(icon: "${location}sleeping.png"),
              _iconGenerator(icon: "${location}no-smartphones.png"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconGenerator(icon: "${location}controller.png"),
              _iconGenerator(icon: "${location}shower.png"),
              _iconGenerator(icon: "${location}take-a-photo.png"),
              _iconGenerator(icon: "${location}sport.png"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconGenerator(icon: "${location}music.png"),
              _iconGenerator(icon: "${location}study.png"),
              _iconGenerator(icon: "${location}coding.png"),
              _iconGenerator(icon: "${location}travel-luggage.png"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconGenerator({required String icon}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _habitIcon = icon;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Image.asset(
          icon,
          height: _habitIcon == icon ? deviceWidth / 6 : deviceWidth / 10,
          width: _habitIcon == icon ? deviceWidth / 6 : deviceWidth / 10,
        ),
      ),
    );
  }
}
