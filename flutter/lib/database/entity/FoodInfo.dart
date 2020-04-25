import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:habit/common/SqfliteDataBase.dart';

class FoodInfo {
  String tableName = "foodInfo";
  Map<String, dynamic> value = {
    "id" : null,
    "name" : null,
    "gkCalorie" : null,
    "eatTimes" : null,
  };
  static Future<void> create() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
      CREATE TABLE IF NOT EXISTS foodInfo (  
        id INTEGER PRIMARY KEY AUTOINCREMENT ,
        name TEXT UNIQUE NOT NULL ,
        gkCalorie REAL NOT NULL ,
        eatTimes INTEGER NOT NULL 
      );
    """);
    debugPrint("create foodInfo");
  }
  
  static Future<void> recreate() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
    DROP TABLE IF EXISTS foodInfo;
    """);
    debugPrint("drop foodInfo");
    await create();
  }

  List<FoodInfo> resultAsList(List<Map<String, dynamic>> dbResult) {
    return dbResult.map((value) {
      FoodInfo entity = new FoodInfo();
      entity.value = value;
      return entity;
    }).toList();
  }
  
  int getId() {
    return value["id"];
  }

  FoodInfo setId(int id) {
    value["id"] = id;
    return this;
  }
  
  String getName() {
    return value["name"];
  }

  FoodInfo setName(String name) {
    value["name"] = name;
    return this;
  }
  
  double getHgkCalorie() {
    return value["gkCalorie"];
  }

  FoodInfo setHgkCalorie(double gkCalorie) {
    value["gkCalorie"] = gkCalorie;
    return this;
  }
  
  int getEatTimes() {
    return value["eatTimes"];
  }

  FoodInfo setEatTimes(int eatTimes) {
    value["eatTimes"] = eatTimes;
    return this;
  }
  
  @override
  String toString() {
    return value.toString();
  }
}
