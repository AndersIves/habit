import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:habit/common/SqfliteDataBase.dart';

class SportInfo {
  String tableName = "sportInfo";
  Map<String, dynamic> value = {
    "id" : null,
    "name" : null,
    "hkCalorie" : null,
    "sportTimes" : null,
  };
  static Future<void> create() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
      CREATE TABLE IF NOT EXISTS sportInfo (  
        id INTEGER PRIMARY KEY AUTOINCREMENT ,
        name TEXT UNIQUE NOT NULL ,
        hkCalorie REAL NOT NULL ,
        sportTimes INTEGER NOT NULL 
      );
    """);
    debugPrint("create sportInfo");
  }
  
  static Future<void> recreate() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
    DROP TABLE IF EXISTS sportInfo;
    """);
    debugPrint("drop sportInfo");
    await create();
  }

  List<SportInfo> resultAsList(List<Map<String, dynamic>> dbResult) {
    return dbResult.map((value) {
      SportInfo entity = new SportInfo();
      entity.value = value;
      return entity;
    }).toList();
  }
  
  int getId() {
    return value["id"];
  }

  SportInfo setId(int id) {
    value["id"] = id;
    return this;
  }
  
  String getName() {
    return value["name"];
  }

  SportInfo setName(String name) {
    value["name"] = name;
    return this;
  }
  
  double getHkCalorie() {
    return value["hkCalorie"];
  }

  SportInfo setHkCalorie(double hkCalorie) {
    value["hkCalorie"] = hkCalorie;
    return this;
  }
  
  int getSportTimes() {
    return value["sportTimes"];
  }

  SportInfo setSportTimes(int sportTimes) {
    value["sportTimes"] = sportTimes;
    return this;
  }
  
  @override
  String toString() {
    return value.toString();
  }
}
