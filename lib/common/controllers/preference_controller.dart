import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesController extends GetxController {
  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    try {
      prefs = await SharedPreferences.getInstance();
      log("SharedPreferences initialized successfully.");
    } catch (e) {
      log("Error initializing SharedPreferences: $e");
    }
  }

  ///

  Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> setString({required String key, required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<bool> deleteString({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success = await prefs.remove(key);
    log("this is the value from prefs controller $key == $success");
    return success;
  }

  Future<String> getString({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String val = prefs.getString(key) ?? "";
    log("this is the value from  prefs controller $key == $val");
    return val;
  }

  ///
  Future<void> setBool({required String key, required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  ///

  Future<bool> getBool({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = prefs.getBool(key) ?? false;
    log("this is the value from  prefs controller $key == $val");
    return val;
  }

  ///

  Future<void> setListString(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  ///

  Future<List<String>?> getListString(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? val = prefs.getStringList(key);
    log("this is the value from  prefs controller $key == $val");
    return val;
  }
}
