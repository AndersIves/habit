import 'package:flutter/cupertino.dart';
import 'package:habit/database/entity/BasicInfo.dart';
import 'package:habit/database/entity/ExerciseInfo.dart';
import 'package:habit/database/entity/FoodInfo.dart';
import 'package:habit/database/entity/LifeInfo.dart';
import 'package:habit/database/entity/ScheduledExercise.dart';
import 'package:habit/database/entity/SportInfo.dart';
import 'package:habit/database/entity/StudyInfo.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDataBase {

  static final String dbPath = "repository.db.sql";
  static Database _database;

  static Future<void> init() async {
    if (_database == null || !_database.isOpen) {
      String databasesPath = "${await getDatabasesPath()}/$dbPath";
      _database = await openDatabase(databasesPath, version: 1);
      await _createTablesIfExists();
      debugPrint("init SqfliteDataBase");
    }
  }

  static Database getInstance() {
    return _database;
  }

  static Future<void> _createTablesIfExists() async {
    await BasicInfo.create();
    await LifeInfo.create();
    await FoodInfo.create();
    await ExerciseInfo.create();
    await SportInfo.create();
    await StudyInfo.create();
    await ScheduledExercise.create();
  }

  static Future<void> resetTables() async {
    await BasicInfo.recreate();
    await LifeInfo.recreate();
    await FoodInfo.recreate();
    await ExerciseInfo.recreate();
    await SportInfo.recreate();
    await StudyInfo.recreate();
    await ScheduledExercise.recreate();
  }
}
