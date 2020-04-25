import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:habit/common/SqfliteDataBase.dart';

class ScheduledExercise {
  String tableName = "scheduledExercise";
  Map<String, dynamic> value = {
    "id" : null,
    "sportId" : null,
    "quantity" : null,
  };
  static Future<void> create() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
      CREATE TABLE IF NOT EXISTS scheduledExercise (  
        id INTEGER PRIMARY KEY AUTOINCREMENT ,
        sportId INTEGER ,
        quantity REAL 
      );
    """);
    debugPrint("create scheduledExercise");
  }
  
  static Future<void> recreate() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
    DROP TABLE IF EXISTS scheduledExercise;
    """);
    debugPrint("drop scheduledExercise");
    await create();
  }

  List<ScheduledExercise> resultAsList(List<Map<String, dynamic>> dbResult) {
    return dbResult.map((value) {
      ScheduledExercise entity = new ScheduledExercise();
      entity.value = value;
      return entity;
    }).toList();
  }
  
  int getId() {
    return value["id"];
  }

  ScheduledExercise setId(int id) {
    value["id"] = id;
    return this;
  }
  
  int getSportId() {
    return value["sportId"];
  }

  ScheduledExercise setSportId(int sportId) {
    value["sportId"] = sportId;
    return this;
  }
  
  double getQuantity() {
    return value["quantity"];
  }

  ScheduledExercise setQuantity(double quantity) {
    value["quantity"] = quantity;
    return this;
  }
  
  @override
  String toString() {
    return value.toString();
  }
}
