import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:habit/common/SqfliteDataBase.dart';

class LifeInfo {
  String tableName = "lifeInfo";
  Map<String, dynamic> value = {
    "id" : null,
    "date" : null,
    "getUpTime" : null,
    "breakfastTime" : null,
    "breakfastId" : null,
    "breakfastQuantity" : null,
    "breakfastMoney" : null,
    "midRestTime" : null,
    "lunchTime" : null,
    "lunchId" : null,
    "lunchQuantity" : null,
    "lunchMoney" : null,
    "dinnerTime" : null,
    "dinnerId" : null,
    "dinnerQuantity" : null,
    "dinnerMoney" : null,
    "restTime" : null,
  };
  static Future<void> create() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
      CREATE TABLE IF NOT EXISTS lifeInfo (  
        id INTEGER PRIMARY KEY AUTOINCREMENT ,
        date INTEGER ,
        getUpTime INTEGER ,
        breakfastTime INTEGER ,
        breakfastId INTEGER ,
        breakfastQuantity REAL ,
        breakfastMoney REAL ,
        midRestTime INTEGER ,
        lunchTime INTEGER ,
        lunchId INTEGER ,
        lunchQuantity REAL ,
        lunchMoney REAL ,
        dinnerTime INTEGER ,
        dinnerId INTEGER ,
        dinnerQuantity REAL ,
        dinnerMoney REAL ,
        restTime INTEGER 
      );
    """);
    debugPrint("create lifeInfo");
  }
  
  static Future<void> recreate() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
    DROP TABLE IF EXISTS lifeInfo;
    """);
    debugPrint("drop lifeInfo");
    await create();
  }

  List<LifeInfo> resultAsList(List<Map<String, dynamic>> dbResult) {
    return dbResult.map((value) {
      LifeInfo entity = new LifeInfo();
      entity.value = value;
      return entity;
    }).toList();
  }
  
  int getId() {
    return value["id"];
  }

  LifeInfo setId(int id) {
    value["id"] = id;
    return this;
  }
  
  int getDate() {
    return value["date"];
  }

  LifeInfo setDate(int date) {
    value["date"] = date;
    return this;
  }
  
  int getGetUpTime() {
    return value["getUpTime"];
  }

  LifeInfo setGetUpTime(int getUpTime) {
    value["getUpTime"] = getUpTime;
    return this;
  }
  
  int getBreakfastTime() {
    return value["breakfastTime"];
  }

  LifeInfo setBreakfastTime(int breakfastTime) {
    value["breakfastTime"] = breakfastTime;
    return this;
  }
  
  int getBreakfastId() {
    return value["breakfastId"];
  }

  LifeInfo setBreakfastId(int breakfastId) {
    value["breakfastId"] = breakfastId;
    return this;
  }
  
  double getBreakfastQuantity() {
    return value["breakfastQuantity"];
  }

  LifeInfo setBreakfastQuantity(double breakfastQuantity) {
    value["breakfastQuantity"] = breakfastQuantity;
    return this;
  }
  
  double getBreakfastMoney() {
    return value["breakfastMoney"];
  }

  LifeInfo setBreakfastMoney(double breakfastMoney) {
    value["breakfastMoney"] = breakfastMoney;
    return this;
  }
  
  int getMidRestTime() {
    return value["midRestTime"];
  }

  LifeInfo setMidRestTime(int midRestTime) {
    value["midRestTime"] = midRestTime;
    return this;
  }
  
  int getLunchTime() {
    return value["lunchTime"];
  }

  LifeInfo setLunchTime(int lunchTime) {
    value["lunchTime"] = lunchTime;
    return this;
  }
  
  int getLunchId() {
    return value["lunchId"];
  }

  LifeInfo setLunchId(int lunchId) {
    value["lunchId"] = lunchId;
    return this;
  }
  
  double getLunchQuantity() {
    return value["lunchQuantity"];
  }

  LifeInfo setLunchQuantity(double lunchQuantity) {
    value["lunchQuantity"] = lunchQuantity;
    return this;
  }
  
  double getLunchMoney() {
    return value["lunchMoney"];
  }

  LifeInfo setLunchMoney(double lunchMoney) {
    value["lunchMoney"] = lunchMoney;
    return this;
  }
  
  int getDinnerTime() {
    return value["dinnerTime"];
  }

  LifeInfo setDinnerTime(int dinnerTime) {
    value["dinnerTime"] = dinnerTime;
    return this;
  }
  
  int getDinnerId() {
    return value["dinnerId"];
  }

  LifeInfo setDinnerId(int dinnerId) {
    value["dinnerId"] = dinnerId;
    return this;
  }
  
  double getDinnerQuantity() {
    return value["dinnerQuantity"];
  }

  LifeInfo setDinnerQuantity(double dinnerQuantity) {
    value["dinnerQuantity"] = dinnerQuantity;
    return this;
  }
  
  double getDinnerMoney() {
    return value["dinnerMoney"];
  }

  LifeInfo setDinnerMoney(double dinnerMoney) {
    value["dinnerMoney"] = dinnerMoney;
    return this;
  }
  
  int getRestTime() {
    return value["restTime"];
  }

  LifeInfo setRestTime(int restTime) {
    value["restTime"] = restTime;
    return this;
  }
  
  @override
  String toString() {
    return value.toString();
  }
}
