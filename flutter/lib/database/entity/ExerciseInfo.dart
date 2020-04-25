import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:habit/common/SqfliteDataBase.dart';

class ExerciseInfo {
  String tableName = "exerciseInfo";
  Map<String, dynamic> value = {
    "id" : null,
    "sportId" : null,
    "exerciseTime" : null,
    "exerciseQuantity" : null,
  };
  static Future<void> create() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
      CREATE TABLE IF NOT EXISTS exerciseInfo (  
        id INTEGER PRIMARY KEY AUTOINCREMENT ,
        sportId INTEGER NOT NULL ,
        exerciseTime INTEGER NOT NULL ,
        exerciseQuantity REAL NOT NULL 
      );
    """);
    debugPrint("create exerciseInfo");
  }
  
  static Future<void> recreate() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
    DROP TABLE IF EXISTS exerciseInfo;
    """);
    debugPrint("drop exerciseInfo");
    await create();
  }

  List<ExerciseInfo> resultAsList(List<Map<String, dynamic>> dbResult) {
    return dbResult.map((value) {
      ExerciseInfo entity = new ExerciseInfo();
      entity.value = value;
      return entity;
    }).toList();
  }
  
  int getId() {
    return value["id"];
  }

  ExerciseInfo setId(int id) {
    value["id"] = id;
    return this;
  }
  
  int getSportId() {
    return value["sportId"];
  }

  ExerciseInfo setSportId(int sportId) {
    value["sportId"] = sportId;
    return this;
  }
  
  int getExerciseTime() {
    return value["exerciseTime"];
  }

  ExerciseInfo setExerciseTime(int exerciseTime) {
    value["exerciseTime"] = exerciseTime;
    return this;
  }
  
  double getExerciseQuantity() {
    return value["exerciseQuantity"];
  }

  ExerciseInfo setExerciseQuantity(double exerciseQuantity) {
    value["exerciseQuantity"] = exerciseQuantity;
    return this;
  }
  
  @override
  String toString() {
    return value.toString();
  }
}
