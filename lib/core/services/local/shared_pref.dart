import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late final SharedPreferences prefs;

  static const String kCounter = "counter";
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setCounter(int value) async {
    await prefs.setInt(kCounter, value);
  }

  static int getCounter() {
    return prefs.getInt(kCounter) ?? 0;
  }
}
