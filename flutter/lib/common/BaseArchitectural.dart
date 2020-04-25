import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'SqfliteDataBase.dart';

abstract class BaseService extends ChangeNotifier {
  BaseService(BuildContext context) {
    init(context);
  }

  void init(BuildContext context) {}
}

abstract class BaseModel extends ChangeNotifier {
  BaseModel(BuildContext context) {
    init(context);
    asyncInit(context);
  }

  void init(BuildContext context) {}

  Future<void> asyncInit(BuildContext context) async {}

  void refresh() {
    notifyListeners();
  }
}
/* demo mapper
class {ENTITY_NAME}Mapper extends CommonMapper<{ENTITY_NAME}> {
  {ENTITY_NAME}Mapper._() : super(new {ENTITY_NAME}());
  static {ENTITY_NAME}Mapper _instance = new {ENTITY_NAME}Mapper._();

  factory {ENTITY_NAME}Mapper() {
    return _instance;
  }
}
 */
abstract class CommonMapper<T extends dynamic> {
  dynamic _currentTypeInstance;


  CommonMapper(dynamic entityI) {
    _currentTypeInstance = entityI;
  }

//  Batch batch;
//
//  void startBatch() {
//    if (batch == null) {
//      batch = SqfliteDataBase.getInstance().batch();
//    }
//    else {
//      throw "already started a batch";
//    }
//  }
//
//  Future<void> commitBatch() async {
//    if (batch == null) {
//      throw "there is no batch exist";
//    }
//    else {
//      List list = await batch.commit();
//      batch = null;
//      debugPrint(list.toString());
//    }
//  }

  // C
  Future<bool> insert(T entity) async {
    try {
      Database database = SqfliteDataBase.getInstance();
      await database.insert(_currentTypeInstance.tableName, entity.value);
      debugPrint("[CommonMapper] insert: ${entity.toString()}");
      return true;
    } catch (e) {
      debugPrint("[CommonMapper] insert fail ${e.toString()}");
      return false;
    }
  }

  // R
  Future<List<T>> selectAll({int limit, String orderBy}) async {
    try {
      Database database = SqfliteDataBase.getInstance();
      List<Map<String, dynamic>> dbResult = await database.query(
        _currentTypeInstance.tableName,
        limit: limit,
        orderBy: orderBy,
      );
      debugPrint(
          "[CommonMapper] selectAll result: ${dbResult.length.toString()}");
      return _currentTypeInstance.resultAsList(dbResult);
    } catch (e) {
      debugPrint("[CommonMapper] selectAll fail ${e.toString()}");
      return null;
    }
  }

  Future<List<T>> selectWhere(String where,
      {int limit, String orderBy}) async {
    try {
      Database database = SqfliteDataBase.getInstance();
      List<Map<String, dynamic>> dbResult = await database.query(
        _currentTypeInstance.tableName,
        limit: limit,
        orderBy: orderBy,
        where: where,
      );
      debugPrint("[CommonMapper] selectWhere result: ${dbResult.length.toString()}");
      return _currentTypeInstance.resultAsList(dbResult);
    } catch (e) {
      debugPrint("[CommonMapper] selectWhere fail ${e.toString()}");
      return null;
    }
  }

  Future<List<T>> selectMatchBy(dynamic entity,
      {int limit, String orderBy}) async {
    try {
      Database database = SqfliteDataBase.getInstance();

      String matches = "";
      entity.value.forEach((key, value) {
        if (value != null) {
          matches += "$key = '${value.toString()}' AND ";
        }
      });
      if (matches.endsWith("AND ")) {
        matches = matches.substring(0, matches.length - 4);
      }

      List<Map<String, dynamic>> dbResult = await database.query(
        _currentTypeInstance.tableName,
        where: matches,
        limit: limit,
        orderBy: orderBy,
      );

      debugPrint(
          "[CommonMapper] selectMatchBy result: ${dbResult.length.toString()}");
      return _currentTypeInstance.resultAsList(dbResult);
    } catch (e) {
      debugPrint("[CommonMapper] selectMatchBy fail ${e.toString()}");
      return null;
    }
  }

  // U
//  Future<bool> updateByFirstKey(T entity) async {
//    try {
//      Database database = SqfliteDataBase.getInstance();
//      await database.update(currentTypeInstance.tableName, entity.value,
//          where:
//              "${entity.value.keys.elementAt(0)} = '${entity.value.values.elementAt(0)}'");
//      debugPrint("[CommonMapper] update: ${entity.toString()}");
//      return true;
//    } catch (e) {
//      debugPrint("[CommonMapper] update fail ${e.toString()}");
//      return false;
//    }
//  }

  Future<bool> updateByFirstKeySelective(T entity) async {
    try {
      Database database = SqfliteDataBase.getInstance();

      entity.value.removeWhere((_, value) {
        return value == null;
      });

      await database.update(_currentTypeInstance.tableName, entity.value,
          where:
              "${entity.value.keys.elementAt(0)} = '${entity.value.values.elementAt(0)}'");
      debugPrint("[CommonMapper] update where: ${entity.toString()}");
      return true;
    } catch (e) {
      debugPrint("[CommonMapper] update fail ${e.toString()}");
      return false;
    }
  }

  // D
  Future<int> delete(T entity) async {
    Database database = SqfliteDataBase.getInstance();

    String matches = "";
    entity.value.forEach((key, value) {
      if (value != null) {
        matches += "$key = '${value.toString()}' AND ";
      }
    });
    if (matches.endsWith("AND ")) {
      matches = matches.substring(0, matches.length - 4);
    }

    int count =
        await database.delete(_currentTypeInstance.tableName, where: matches);
    debugPrint("[CommonMapper] delete $count row");
    return count;
  }
}
