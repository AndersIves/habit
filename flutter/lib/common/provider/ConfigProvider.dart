import 'package:flutter/material.dart';
import 'package:habit/common/LocalData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider extends ChangeNotifier {
  int getUpTimeStart;
  int getUpTimeEnd;

  int breakfastTimeStart;
  int breakfastTimeEnd;

  int lunchTimeStart;
  int lunchTimeEnd;

  int midRestTimeStart;
  int midRestTimeEnd;

  int dinnerTimeStart;
  int dinnerTimeEnd;

  int restTimeStart;
  int restTimeEnd;

  void init() {
    load();
    store();

    debugPrint("""init ConfigProvider to:
      getUpTimeStart = ${DateTime.fromMillisecondsSinceEpoch(getUpTimeStart).toString().substring(11, 16)}
      getUpTimeEnd = ${DateTime.fromMillisecondsSinceEpoch(getUpTimeEnd).toString().substring(11, 16)}
      
      breakfastTimeStart = ${DateTime.fromMillisecondsSinceEpoch(breakfastTimeStart).toString().substring(11, 16)}
      breakfastTimeEnd = ${DateTime.fromMillisecondsSinceEpoch(breakfastTimeEnd).toString().substring(11, 16)}
      
      midRestTimeStart = ${DateTime.fromMillisecondsSinceEpoch(midRestTimeStart).toString().substring(11, 16)}
      midRestTimeEnd = ${DateTime.fromMillisecondsSinceEpoch(midRestTimeEnd).toString().substring(11, 16)}
      
      lunchTimeStart = ${DateTime.fromMillisecondsSinceEpoch(lunchTimeStart).toString().substring(11, 16)}
      lunchTimeEnd = ${DateTime.fromMillisecondsSinceEpoch(lunchTimeEnd).toString().substring(11, 16)}
      
      dinnerTimeStart = ${DateTime.fromMillisecondsSinceEpoch(dinnerTimeStart).toString().substring(11, 16)}
      dinnerTimeEnd = ${DateTime.fromMillisecondsSinceEpoch(dinnerTimeEnd).toString().substring(11, 16)}
      
      restTimeStart = ${DateTime.fromMillisecondsSinceEpoch(restTimeStart).toString().substring(11, 16)}
      restTimeEnd = ${DateTime.fromMillisecondsSinceEpoch(restTimeEnd).toString().substring(11, 16)}
      """);
  }

  void load() {
    SharedPreferences sp = LocalData.getInstance();
    getUpTimeStart = sp.getInt("getUpTimeStart") ?? DateTime(1,1,1,6).millisecondsSinceEpoch;
    getUpTimeEnd = sp.getInt("getUpTimeEnd") ?? DateTime(1,1,1,7).millisecondsSinceEpoch;

    breakfastTimeStart = sp.getInt("breakfastTimeStart") ?? DateTime(1,1,1,7).millisecondsSinceEpoch;
    breakfastTimeEnd = sp.getInt("breakfastTimeEnd") ?? DateTime(1,1,1,8).millisecondsSinceEpoch;

    lunchTimeStart = sp.getInt("lunchTimeStart") ?? DateTime(1,1,1,12).millisecondsSinceEpoch;
    lunchTimeEnd = sp.getInt("lunchTimeEnd") ?? DateTime(1,1,1,13).millisecondsSinceEpoch;

    midRestTimeStart = sp.getInt("midRestTimeStart") ?? DateTime(1,1,1,13).millisecondsSinceEpoch;
    midRestTimeEnd = sp.getInt("midRestTimeEnd") ?? DateTime(1,1,1,14).millisecondsSinceEpoch;

    dinnerTimeStart = sp.getInt("dinnerTimeStart") ?? DateTime(1,1,1,17).millisecondsSinceEpoch;
    dinnerTimeEnd = sp.getInt("dinnerTimeEnd") ?? DateTime(1,1,1,18).millisecondsSinceEpoch;

    restTimeStart = sp.getInt("restTimeStart") ?? DateTime(1,1,1,21).millisecondsSinceEpoch;
    restTimeEnd = sp.getInt("restTimeEnd") ?? DateTime(1,1,1,22).millisecondsSinceEpoch;
  }

  void store() {
    SharedPreferences sp = LocalData.getInstance();
    sp.setInt("getUpTimeStart", getUpTimeStart);
    sp.setInt("getUpTimeEnd", getUpTimeEnd);

    sp.setInt("breakfastTimeStart", breakfastTimeStart);
    sp.setInt("breakfastTimeEnd", breakfastTimeEnd);

    sp.setInt("lunchTimeStart", lunchTimeStart);
    sp.setInt("lunchTimeEnd", lunchTimeEnd);

    sp.setInt("midRestTimeStart", midRestTimeStart);
    sp.setInt("midRestTimeEnd", midRestTimeEnd);

    sp.setInt("dinnerTimeStart", dinnerTimeStart);
    sp.setInt("dinnerTimeEnd", dinnerTimeEnd);

    sp.setInt("restTimeStart", restTimeStart);
    sp.setInt("restTimeEnd", restTimeEnd);
  }

  void refresh() {
    notifyListeners();
  }

}