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
    final String habitpath = "$uid/Habits/HabitData/${habit["title"]}";

    try {
      final DocumentReference<Map<String, dynamic>> cloudRef =
          _firestore.doc(habitpath);

      await cloudRef.set(habit);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteHabitData() async {
    final String habitpath = "$uid/Habits/HabitData";

    try {
      final QuerySnapshot allDocuments =
          await _firestore.collection(habitpath).get();
      for (final DocumentSnapshot doc in allDocuments.docs) {
        final DocumentReference<Map<String, dynamic>> cloudRef =
            _firestore.doc(doc.reference.path);
        cloudRef.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadTasksData(Map<String, dynamic> task) async {
    final String habitpath = "$uid/Tasks/TaskData/${task["title"]}";
    final DocumentReference<Map<String, dynamic>> cloudRef =
        _firestore.doc(habitpath);
    await cloudRef.set(task);
  }

  Future<List<Habit>> getHabitData() async {
    final String habitpath = "$uid/Habits/HabitData";
    try {
      final CollectionReference refrence = _firestore.collection(habitpath);
      final QuerySnapshot habitSnapshot = await refrence.get();
      final List<Habit> restoredHabits = [];
      final allData = habitSnapshot.docs.map((doc) => doc.data()).toList();

      for (final data in allData) {
        restoredHabits.add(Habit.fromMap(data! as Map<String, dynamic>));
      }
      return restoredHabits;
    } on Exception {
      rethrow;
    }
  }
}
