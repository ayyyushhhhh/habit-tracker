import 'package:flutter/material.dart';

class AddHabitcard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(20),
      height: deviceHeight / 15,
      width: deviceWidth / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.purpleAccent.shade100,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: deviceHeight / 10,
            ),
            Text(
              "Click Here to Add",
              style: TextStyle(
                  fontSize: deviceHeight / 50,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue),
            ),
            Text(
              "Custom Habit",
              style: TextStyle(
                  fontSize: deviceHeight / 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
