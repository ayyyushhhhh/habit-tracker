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
}
