import 'package:flutter/material.dart';
import 'package:time_table/utils/habit%20tracker/habit_tracker_colors.dart';

class AddHabitcard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(20),
      height: deviceHeight / 15,
      width: deviceWidth / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.purpleAccent.shade100,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                color: Colors.blue,
              ),
            ),
            Text(
              "Custom Habit",
              style: TextStyle(
                fontSize: deviceHeight / 40,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class AddHabitcard extends StatelessWidget {
//   const AddHabitcard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final deviceHeight = MediaQuery.of(context).size.height;
//     // final deviceWidth = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         Container(
//           height: deviceHeight / 4,
//           width: deviceHeight / 4,
//           margin: const EdgeInsets.all(20),
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: kprimaryColor,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.add,
//                 size: 80,
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 2,
//         ),
//         Text(
//           "Add Habit",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         )
//       ],
//     );
//   }
// }
