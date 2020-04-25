import 'package:dio/dio.dart';

class Status {
  static const String OK = "OK";
  static const String RES_REPEATED = "RES_REPEATED";
  static const String RES_NOT_MATCH = "RES_NOT_MATCH";
  static const String INVALID_AUTHORIZE = "INVALID_AUTHORIZE";
  static const String RES_NOT_FOUND = "RES_NOT_FOUND";
  static const String CREATE_FAIL = "CREATE_FAIL";
  static const String CONNECT_FAIL = "CONNECT_FAIL";
  static const String RES_NOT_ALLOW = "RES_NOT_ALLOW";

  static String of(Response response) {
    if (response == null) {
      return CONNECT_FAIL;
    }
    else {
      return response.headers.value("responseCode");
    }
  }
}