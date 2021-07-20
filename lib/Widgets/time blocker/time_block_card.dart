import 'package:flutter/material.dart';
import 'package:time_table/models/time_blocker/time_block_model.dart';

class TimeBlockCard extends StatelessWidget {
  final TimeBlockModel blockTask;
  const TimeBlockCard({Key? key, required this.blockTask});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blockTask.taskTitle,
            style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.schedule,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                blockTask.from.format(context),
                style: TextStyle(color: Colors.black),
              ),
              Text(" - ", style: TextStyle(color: Colors.black)),
              Text(
                blockTask.to.format(context),
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            blockTask.taskDescription,
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1),
          ),
        ],
      ),
    );
  }
}
