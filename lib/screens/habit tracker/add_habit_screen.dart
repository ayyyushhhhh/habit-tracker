import 'package:flutter/material.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  String? _habitIcon;
  String? habitTitle;
  String? description;
  String location = "assets/icons/";
  double deviceWidth = 0;
  void _saveHabit() {
    if (habitTitle != null && _habitIcon != null && description != null) {
      Habit habit = Habit(
          title: habitTitle.toString(),
          icon: _habitIcon!,
          completedDates: [],
          skipDates: [],
          index: 0,
          lastIndex: 0,
          streaks: 0,
          dateCreated: DateTime.now(),
          description: description!);
      final habitbox = HabitBox.getHabitBox();
      habitbox.put(habit.title, habit);
      Navigator.pop(context);
    } else if (habitTitle == null) {
      _showSnackbar(context, "Give some title", "ok!");
    } else if (description == null) {
      _showSnackbar(context, "Give some title", "ok!");
    } else if (_habitIcon == null) {
      _showSnackbar(context, "Select an icon", "ok!");
    }
  }

  void _showSnackbar(BuildContext context, String title, String label) {
    final snackBar = SnackBar(
      content: Text(title),
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
        body: CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: deviceHeight / 8,
            pinned: true,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Add Habit",
                style: TextStyle(
                    // fontSize: deviceWidth / 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Habit Title",
                        style: TextStyle(
                            fontSize: deviceHeight / 32,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            habitTitle = value;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none),
                              hintText: "Enter Habit title eg,Running"),
                          maxLength: 10,
                        ),
                      ),
                      Text(
                        "Habit Description",
                        style: TextStyle(
                            fontSize: deviceHeight / 32,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            description = value;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none),
                              hintText:
                                  "Add a little description eg, run 10 km "),
                          maxLength: 20,
                        ),
                      ),
                      Text(
                        "Choose an Icon",
                        style: TextStyle(
                            fontSize: deviceHeight / 32,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      iconsSelector(),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        child: Container(
                          height: deviceHeight / 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.purpleAccent.shade100),
                          child: GestureDetector(
                            onTap: () {
                              _saveHabit();
                            },
                            child: Center(
                              child: Text(
                                "Add Habit",
                                style: TextStyle(
                                    fontSize: deviceHeight / 16,
                                    fontWeight: FontWeight.w800),
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
        ]),
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
        margin: EdgeInsets.all(5),
        child: Image.asset(
          icon,
          height: _habitIcon == icon ? deviceWidth / 6 : deviceWidth / 10,
          width: _habitIcon == icon ? deviceWidth / 6 : deviceWidth / 10,
        ),
      ),
    );
  }
}
