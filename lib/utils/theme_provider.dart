import 'package:flutter/material.dart';
import 'package:time_table/utils/prefrences.dart';

enum ThemeType { DarkTheme, LightTheme }

class ThemeManager with ChangeNotifier {
  List<ThemeData> appThemeData = [
    ThemeData.dark().copyWith(
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: "San Francisco"),
    ),
    ThemeData.light().copyWith(
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: "San Francisco",
            bodyColor: Colors.black,
            displayColor: Colors.white,
          ),
      primaryColor: Colors.teal.shade700,
      appBarTheme: AppBarTheme(
        color: Colors.teal,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
    ),
  ];
  ThemeData? appTheme;
  ThemeManager() {
    appTheme = appThemeData[Prefrences.getSavedTheme()];
  }

  void updateTheme(ThemeType themeType) {
    if (themeType == ThemeType.DarkTheme) {
      appTheme = appThemeData[0];
      Prefrences.saveTheme(0);
      notifyListeners();
    } else if (themeType == ThemeType.LightTheme) {
      appTheme = appThemeData[1];
      Prefrences.saveTheme(1);
      notifyListeners();
    }
  }
}
