import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefrences {
  static SharedPreferences? preferences;

  static void init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static String getDate() {
    String? date = preferences!.getString("currentDate");
    if (date == null) {
      Prefrences.saveDate(DateTime.now());
      return DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
    return date;
  }

  static void saveDate(DateTime date) async {
    String dateNow = DateFormat('dd-MM-yyyy').format(date);
    preferences!.setString("currentDate", dateNow);
  }

  static void saveName(String name) async {
    preferences!.setString("username", name);
  }

  static String getuserName() {
    String? date = preferences!.getString("username");

    return date ?? "";
  }

  static void saveTheme(int themeIndex) async {
    preferences!.setInt("themeindex", themeIndex);
  }

  static int getSavedTheme() {
    int? index = preferences!.getInt("themeindex");
    return index ?? 0;
  }

  static int getSavedDP() {
    int? index = preferences!.getInt("imageIndex");
    return index ?? 1;
  }

  static void saveDP(int imageIndex) async {
    preferences!.setInt("imageIndex", imageIndex);
  }
}
