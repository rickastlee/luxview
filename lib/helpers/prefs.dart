import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static void writeData(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is List) {
      prefs.setStringList(key, value as List<String>);
    } else {
      throw Exception('Invalid Type');
    }
  }

  static Future<T?> readData<T>(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (T == bool) {
      return prefs.getBool(key) as T?;
    } else if (T == double) {
      return prefs.getDouble(key) as T?;
    } else if (T == int) {
      return prefs.getInt(key) as T?;
    } else if (T == String) {
      return prefs.getString(key) as T?;
    } else if (T == List<String>) {
      return prefs.getStringList(key) as T?;
    } else {
      return prefs.get(key) as T?;
    }
  }

  static Future<bool> deleteData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
