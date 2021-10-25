import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_table/utils/prefrences.dart';

class User extends ChangeNotifier {
  String name = Prefrences.getuserName();
  int profilePic = Prefrences.getSavedDP();

  String get getName {
    return name;
  }

  String get getProfilePic {
    return profilePic.toString();
  }

  void updateName(String nameInput) {
    Prefrences.saveName(nameInput);
    name = Prefrences.getuserName();
    notifyListeners();
  }

  void updateDP(int imageIndex) {
    Prefrences.saveDP(imageIndex);
    profilePic = Prefrences.getSavedDP();
    notifyListeners();
  }
}
