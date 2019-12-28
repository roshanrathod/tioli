import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static Future<void> strAddKey(keyName, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(keyName, value);
  }

  static Future<String> strGetValue(keyName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyName);
  }

  static Future<void> boolAddKey(keyName, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(keyName, value);
  }

  static Future<bool> boolGetValue(keyName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyName) ?? false;
  }
}