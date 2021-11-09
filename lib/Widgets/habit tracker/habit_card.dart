import 'package:flutter/material.dart';
import 'package:time_table/hive%20boxes/habit_box.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';
import 'package:time_table/utils/habit%20tracker/habit_tracker_colors.dart';

// class HabitCard extends StatefulWidget {
//   final Habit habit;

//   const HabitCard({required this.habit});

//   @override
//   _HabitCardState createState() => _HabitCardState();
// }

// class _HabitCardState extends State<HabitCard> {
//   void toggleDoneHabit() {
//     if (widget.habit.isDone == false) {
//       setState(() {
//         widget.habit.isDone = true;

//         final habitbox = HabitBox.getHabitBox();
//         final DateTime now = DateTime.now();
//         final DateTime date = DateTime(now.year, now.month, now.day);
//         habitbox.put(
//           widget.habit.title,
//           widget.habit.updateWith(completeDate: date),
//         );
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceHeight = MediaQuery.of(context).size.height;
//     final deviceWidth = MediaQuery.of(context).size.width;
//     return Container(
//       margin: const EdgeInsets.all(20),
//       padding: EdgeInsets.all(10),
//       height: deviceHeight / 5,
//       width: deviceWidth / 2,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: kHeadingTextColor,
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               widget.habit.icon,
//               width: deviceHeight / 8,
//               height: deviceHeight / 8,
//             ),
//             Text(
//               widget.habit.title,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: deviceHeight / 28,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             Container(
//               padding: const EdgeInsets.all(4),
//               child: Text(
//                 widget.habit.description,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: deviceWidth / 22,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             Spacer(),
//             Text(
//               "(Click here for details)",
//               style: TextStyle(fontSize: deviceWidth / 30, color: Colors.blue),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: IconButton(
//                 onPressed: toggleDoneHabit,
//                 icon: const Icon(Icons.check_circle),
//                 iconSize: deviceHeight / 15,
//                 color: widget.habit.isDone == false
//                     ? Colors.grey
//                     : Colors.green.shade900,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class HabitCard extends StatefulWidget {
  final Habit habit;

  const HabitCard({required this.habit});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  void _toggleDoneHabit() {
    if (widget.habit.isDone == false) {
      setState(() {
        widget.habit.isDone = true;

        final habitbox = HabitBox.getHabitBox();
        final DateTime now = DateTime.now();
        final DateTime date = DateTime(now.year, now.month, now.day);

        habitbox.put(
          widget.habit.title,
          widget.habit.updateWith(completeDate: date, isCompleted: true),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height / 1.5;
    final deviceWidth = MediaQuery.of(context).size.width / 1.5;
    return Column(
      children: [
        Container(
          height: deviceHeight / 4,
          width: deviceHeight / 4,
          margin: const EdgeInsets.all(20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kcardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: deviceWidth / 10,
                child: Image.asset(widget.habit.icon),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _toggleDoneHabit,
                child: CircleAvatar(
                  radius: deviceWidth / 20,
                  backgroundColor: widget.habit.isDone
                      ? Colors.green.shade600
                      : Colors.red.shade700,
                  child: Text(
                    widget.habit.streaks.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth / 22,
                    ),
                  ),
                ),
              ),

              // IconButton(
              //   onPressed: _toggleDoneHabit,
              //   icon: const Icon(Icons.check_circle),
              //   iconSize: deviceHeight / 22,
              //   color: widget.habit.isDone == false
              //       ? Colors.grey
              //       : Colors.green.shade900,
              // ),
            ],
          ),
        ),
        SizedBox(
          height: 2,
        ),
        SizedBox(
          width: deviceHeight / 4,
          child: Text(
            widget.habit.title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
