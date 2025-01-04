import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  static Future<void> saveData(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      await prefs.remove(key);
    }
    await prefs.setBool(key, value);
  }

  static Future<bool> getData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? c = prefs.getBool(key);
    if (c == null) {
      return false;
    } else {
      return c;
    }
  }

  //=======================
  static Future<bool> getReminder(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? c = prefs.getBool(key);
    if (c == null) {
      return true;
    }
    return c;
  }

  //========= xxxxxxxxxxxx ===============//
  static Future<void> saveDataMusic(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      await prefs.remove(key);
    }
    await prefs.setStringList(key, value);
    log("save $key");
  }

  //*************
  static Future<List<String>> getDataMusic(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList(key);
    if (data == null) {
      return [];
    }
    return data;
  }

  //===========
  static Future<void> setRemeber(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      await prefs.remove(key);
    }
    prefs.setInt(key, value);
  }

  static Future<int> getRemember(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? r = prefs.getInt(key);
    if (r == null) {
      return 15;
    }
    return r;
  }
}
