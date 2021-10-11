import 'package:flutter/material.dart';
import 'package:time_table/utils/habit%20tracker/prefrences.dart';

class User with ChangeNotifier {
  String name = Prefrences.getuserName();
  int profilePic = Prefrences.getSavedDP();
  void updateName() {
    name = Prefrences.getuserName();
    notifyListeners();
  }

  void updateDP(imageIndex) {
    Prefrences.saveDP(imageIndex);
    profilePic = Prefrences.getSavedDP();
    notifyListeners();
  }
}
