import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';

import 'package:habit/common/I18N.dart';

class ConvertUtils {
  static int offset = DateTime.now().timeZoneOffset.inMilliseconds;

  static String packString(Object s) {
    return s == null ? I18N.of("无数据") : s.toString();
  }

  static String md5Encode(String s) {
    return md5.convert(Utf8Encoder().convert("ha${s}bit")).toString();
  }

  static double localDaysSinceEpoch(DateTime dateTime) {
    return (dateTime.millisecondsSinceEpoch + offset) / 86400000;
  }

  static DateTime dateTimeOfLocalDaysSinceEpoch(double daysSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(
        (daysSinceEpoch * 86400000).round() - offset);
  }

  static DateTime dateOfDateTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String timeFormMillisecondsSinceEpoch(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch)
        .toString()
        .substring(11, 16);
  }

  static double hourFormMilliseconds(int milliseconds) {
    return milliseconds / 1000 / 60 / 60;
  }

  static double hourFormMillisecondsSinceEpoch(int millisecondsSinceEpoch) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return Duration(hours: time.hour, minutes: time.minute, seconds: time.second)
            .inMilliseconds /
        1000 /
        60 /
        60;
  }

  static double fixedDouble(double value, int fix) {
    int fixNum = pow(10, fix);
    return (value * fixNum).round() / fixNum;
  }
}
