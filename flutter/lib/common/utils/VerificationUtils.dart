import 'package:flutter/material.dart';

class VerifyUtils {
  static final RegExp _regexUserName =
      new RegExp("^[\u4e00-\u9fa5a-zA-Z0-9]{2,8}\$");
  static final RegExp _regexEmail = new RegExp("^\\w+@\\w+(\.\\w+)+\$");
  static final RegExp _regexPassword =
      new RegExp("^(?=.*[a-z])(?=.*[A-Z])[a-zA-Z0-9#?!@\$%^&*,]{8,16}\$");

  static bool isUserName(String s) {
    if (s == null || s.isEmpty) {
      return false;
    }
    return _regexUserName.hasMatch(s);
  }

  static bool isEmail(String s) {
    if (s == null || s.isEmpty) {
      return false;
    }
    return _regexEmail.hasMatch(s);
  }

  static bool isPassword(String s) {
    if (s == null || s.isEmpty) {
      return false;
    }
    return _regexPassword.hasMatch(s);
  }

  static bool nowIsBetweenTime(int a, int b) {
    DateTime now = DateTime.now();
    DateTime nowTime = DateTime(1, 1, 1, now.hour, now.minute, now.second);
    return a <= nowTime.millisecondsSinceEpoch &&
        nowTime.millisecondsSinceEpoch <= b;
  }

  static bool isBetweenTime(int a, int v, int b) {
    DateTime vTime = DateTime.fromMillisecondsSinceEpoch(v);
    DateTime nowTime = DateTime(1, 1, 1, vTime.hour, vTime.minute, vTime.second);
    return a <= nowTime.millisecondsSinceEpoch &&
        nowTime.millisecondsSinceEpoch <= b;
  }
}
