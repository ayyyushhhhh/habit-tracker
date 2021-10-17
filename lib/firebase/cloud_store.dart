import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_table/firebase/firebase_authentication.dart';

class CloudData {
  late FirebaseFirestore _firestore;
  String uid = FirebaseAuthentication.getUserUid;
  CloudData() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> uploadHabitData(Map<String, dynamic> habit) async {
    String habitpath = "$uid/Habits/HabitData/${habit["title"]}";
    final DocumentReference<Map<String, dynamic>> cloudRef =
        _firestore.doc(habitpath);
    await cloudRef.set(habit);
  }

  Future<void> uploadTasksData(Map<String, dynamic> task) async {
    String habitpath = "$uid/Tasks/TaskData/${task["title"]}";
    final DocumentReference<Map<String, dynamic>> cloudRef =
        _firestore.doc(habitpath);
    await cloudRef.set(task);
  }

  Future<void> getHabitData(Map<String, dynamic> habit) async {
    String habitpath = "$uid/Habits/HabitData";
    final refrence = _firestore.collection(habitpath);
    final habitSnapshot = refrence.snapshots();
    habitSnapshot.listen((habits) {
      habits.docs.forEach((habit) {
        print(habit.data());
      });
    });
  }
}
