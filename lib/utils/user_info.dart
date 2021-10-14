import 'package:flutter/material.dart';
import 'package:time_table/utils/prefrences.dart';
import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  String name = Prefrences.getuserName();
  int profilePic = Prefrences.getSavedDP();

  String get getName {
    return name;
  }

  String get getProfilePic {
    return profilePic.toString();
  }

  void updateName(nameInput) {
    Prefrences.saveName(nameInput);
    name = Prefrences.getuserName();
    notifyListeners();
  }

  void updateDP(imageIndex) {
    Prefrences.saveDP(imageIndex);
    profilePic = Prefrences.getSavedDP();
    notifyListeners();
  }
}
