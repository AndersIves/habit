import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:habit/common/SqfliteDataBase.dart';

class StudyInfo {
  String tableName = "studyInfo";
  Map<String, dynamic> value = {
    "id" : null,
    "date" : null,
    "courseName" : null,
    "isLate" : null,
    "isAbsent" : null,
    "isHomeWorkDone" : null,
    "homeworks" : null,
    "difficulty" : null,
    "isTroublesSolved" : null,
    "troubles" : null,
  };
  static Future<void> create() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
      CREATE TABLE IF NOT EXISTS studyInfo (  
        id INTEGER PRIMARY KEY AUTOINCREMENT ,
        date INTEGER ,
        courseName TEXT ,
        isLate INTEGER ,
        isAbsent INTEGER ,
        isHomeWorkDone INTEGER ,
        homeworks TEXT ,
        difficulty INTEGER ,
        isTroublesSolved INTEGER ,
        troubles TEXT 
      );
    """);
    debugPrint("create studyInfo");
  }
  
  static Future<void> recreate() async {
    Database database = SqfliteDataBase.getInstance();
    await database.execute("""
    DROP TABLE IF EXISTS studyInfo;
    """);
    debugPrint("drop studyInfo");
    await create();
  }

  List<StudyInfo> resultAsList(List<Map<String, dynamic>> dbResult) {
    return dbResult.map((value) {
      StudyInfo entity = new StudyInfo();
      entity.value = value;
      return entity;
    }).toList();
  }
  
  int getId() {
    return value["id"];
  }

  StudyInfo setId(int id) {
    value["id"] = id;
    return this;
  }
  
  int getDate() {
    return value["date"];
  }

  StudyInfo setDate(int date) {
    value["date"] = date;
    return this;
  }
  
  String getCourseName() {
    return value["courseName"];
  }

  StudyInfo setCourseName(String courseName) {
    value["courseName"] = courseName;
    return this;
  }
  
  int getIsLate() {
    return value["isLate"];
  }

  StudyInfo setIsLate(int isLate) {
    value["isLate"] = isLate;
    return this;
  }
  
  int getIsAbsent() {
    return value["isAbsent"];
  }

  StudyInfo setIsAbsent(int isAbsent) {
    value["isAbsent"] = isAbsent;
    return this;
  }
  
  int getIsHomeWorkDone() {
    return value["isHomeWorkDone"];
  }

  StudyInfo setIsHomeWorkDone(int isHomeWorkDone) {
    value["isHomeWorkDone"] = isHomeWorkDone;
    return this;
  }
  
  String getHomeworks() {
    return value["homeworks"];
  }

  StudyInfo setHomeworks(String homeworks) {
    value["homeworks"] = homeworks;
    return this;
  }
  
  int getDifficulty() {
    return value["difficulty"];
  }

  StudyInfo setDifficulty(int difficulty) {
    value["difficulty"] = difficulty;
    return this;
  }
  
  int getIsTroublesSolved() {
    return value["isTroublesSolved"];
  }

  StudyInfo setIsTroublesSolved(int isTroublesSolved) {
    value["isTroublesSolved"] = isTroublesSolved;
    return this;
  }
  
  String getTroubles() {
    return value["troubles"];
  }

  StudyInfo setTroubles(String troubles) {
    value["troubles"] = troubles;
    return this;
  }
  
  @override
  String toString() {
    return value.toString();
  }
}
