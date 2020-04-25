import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:habit/common/SqfliteDataBase.dart';

class BasicInfo {
  String tableName = "basicInfo";
  Map<String, dynamic> value = {
    "id" : null,
    "height" : null,
    "weight" : null,
    "breastLine" : null,
    "waistLine" : null,
    "hipLine" : null,
    "date" : null,
  };
  static Future<void> create() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
      CREATE TABLE IF NOT EXISTS basicInfo (  
        id INTEGER PRIMARY KEY AUTOINCREMENT ,
        height REAL NOT NULL ,
        weight REAL NOT NULL ,
        breastLine REAL NOT NULL ,
        waistLine REAL NOT NULL ,
        hipLine REAL NOT NULL ,
        date INTEGER NOT NULL 
      );
    """);
    debugPrint("create basicInfo");
  }
  
  static Future<void> recreate() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
    DROP TABLE IF EXISTS basicInfo;
    """);
    debugPrint("drop basicInfo");
    await create();
  }

  List<BasicInfo> resultAsList(List<Map<String, dynamic>> dbResult) {
    return dbResult.map((value) {
      BasicInfo entity = new BasicInfo();
      entity.value = value;
      return entity;
    }).toList();
  }
  
  int getId() {
    return value["id"];
  }

  BasicInfo setId(int id) {
    value["id"] = id;
    return this;
  }
  
  double getHeight() {
    return value["height"];
  }

  BasicInfo setHeight(double height) {
    value["height"] = height;
    return this;
  }
  
  double getWeight() {
    return value["weight"];
  }

  BasicInfo setWeight(double weight) {
    value["weight"] = weight;
    return this;
  }
  
  double getBreastLine() {
    return value["breastLine"];
  }

  BasicInfo setBreastLine(double cheatLine) {
    value["breastLine"] = cheatLine;
    return this;
  }
  
  double getWaistLine() {
    return value["waistLine"];
  }

  BasicInfo setWaistLine(double waistLine) {
    value["waistLine"] = waistLine;
    return this;
  }
  
  double getHipLine() {
    return value["hipLine"];
  }

  BasicInfo setHipLine(double hipLine) {
    value["hipLine"] = hipLine;
    return this;
  }
  
  int getDate() {
    return value["date"];
  }

  BasicInfo setDate(int date) {
    value["date"] = date;
    return this;
  }
  
  @override
  String toString() {
    return value.toString();
  }
}
