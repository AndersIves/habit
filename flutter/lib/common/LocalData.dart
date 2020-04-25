import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static SharedPreferences _sharedPreferences;
  static init() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
      debugPrint("init LocalData");
    }
  }

  static SharedPreferences getInstance() {
    return _sharedPreferences;
  }
}