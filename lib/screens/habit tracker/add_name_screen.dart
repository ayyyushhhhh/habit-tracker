import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_table/screens/habit%20tracker/habit_tracker_screen.dart';
import 'package:time_table/utils/habit%20tracker/prefrences.dart';

class AddNameScreen extends StatefulWidget {
  const AddNameScreen({Key? key}) : super(key: key);

  @override
  _AddNameScreenState createState() => _AddNameScreenState();
}

class _AddNameScreenState extends State<AddNameScreen> {
  String? userName;
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              if (userName != null && userName != "") {
                Prefrences.saveName(userName.toString());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return HabitTrackerScreen();
                  }),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: new Text("Enter your Name"),
                    content: new Text("Entered name is not valid"),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Ok"),
                      )
                    ],
                  ),
                );
              }
            },
            child: Text(
              "Let's Go",
              style: TextStyle(fontSize: 24),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: SvgPicture.asset(
                "assets/svg/profile_name.svg",
                height: 250,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Please Enter Your Name",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: deviceHeight / 12,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black12,
              ),
              child: TextField(
                onChanged: (value) {
                  userName = value;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                    hintText: "Enter Your First Name "),
                maxLength: 10,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 20,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
