import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_table/firebase/firebase_authentication.dart';
import 'package:time_table/models/habit_tracker/habit_model.dart';

class CloudData {
  late FirebaseFirestore _firestore;
  String uid = FirebaseAuthentication.getUserUid;
  CloudData() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> uploadHabitData(Map<String, dynamic> habit) async {
    String habitpath = "$uid/Habits/HabitData/${habit["title"]}";
    try {
      final DocumentReference<Map<String, dynamic>> cloudRef =
          _firestore.doc(habitpath);
      await cloudRef.set(habit);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> uploadTasksData(Map<String, dynamic> task) async {
    String habitpath = "$uid/Tasks/TaskData/${task["title"]}";
    final DocumentReference<Map<String, dynamic>> cloudRef =
        _firestore.doc(habitpath);
    await cloudRef.set(task);
  }

  Future<List<Habit>> getHabitData() async {
    String habitpath = "$uid/Habits/HabitData";
    try {
      CollectionReference refrence = _firestore.collection(habitpath);
      QuerySnapshot habitSnapshot = await refrence.get();
      List<Habit> restoredHabits = [];
      final allData = habitSnapshot.docs.map((doc) => doc.data()).toList();

      for (var data in allData) {
        restoredHabits.add(Habit.fromMap(data as Map<String, dynamic>));
      }

      return restoredHabits;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
