import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class Prefrences {
  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static String getDate() {
    final String? date = preferences!.getString("currentDate");
    if (date == null) {
      Prefrences.saveDate(DateTime.now());
      return DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
    return date;
  }

  static void saveDate(DateTime date) {
    final String dateNow = DateFormat('dd-MM-yyyy').format(date);
    preferences!.setString("currentDate", dateNow);
  }

  static void saveName(String name) {
    preferences!.setString("username", name);
  }

  static String getuserName() {
    final String? date = preferences!.getString("username");

    return date ?? "";
  }

  static void saveTheme(int themeIndex) {
    preferences!.setInt("themeindex", themeIndex);
  }

  static int getSavedTheme() {
    final int? index = preferences!.getInt("themeindex");
    return index ?? 0;
  }

  static int getSavedDP() {
    final int? index = preferences!.getInt("imageIndex");
    return index ?? 1;
  }

  static void saveDP(int imageIndex) {
    preferences!.setInt("imageIndex", imageIndex);
  }
}
