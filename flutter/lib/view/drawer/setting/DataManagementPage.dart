import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/SqfliteDataBase.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/database/entity/BasicInfo.dart';
import 'package:habit/database/entity/ExerciseInfo.dart';
import 'package:habit/database/entity/FoodInfo.dart';
import 'package:habit/database/entity/LifeInfo.dart';
import 'package:habit/database/entity/SportInfo.dart';
import 'package:habit/database/mapper/BasicInfoMapper.dart';
import 'package:habit/database/mapper/ExerciseInfoMapper.dart';
import 'package:habit/database/mapper/FoodInfoMapper.dart';
import 'package:habit/database/mapper/LifeInfoMapper.dart';
import 'package:habit/database/mapper/SportInfoMapper.dart';
import 'package:habit/database/mapper/StudyInfoMapper.dart';
import 'package:habit/network/Repository.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class DataManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataManagementPageService>(
            create: (_) => DataManagementPageService(context)),
        ChangeNotifierProvider<DataManagementPageModel>(
            create: (_) => DataManagementPageModel(context)),
      ],
      child: _DataManagementPageView(),
    );
  }
}

// model
class DataManagementPageModel extends BaseModel {
  DataManagementPageModel(BuildContext context) : super(context);

  bool isRequesting;

  int basicInfoCount;
  int lifeInfoCount;
  int exerciseInfoCount;
  int studyInfoCount;

  @override
  void init(BuildContext context) {
    isRequesting = true;
  }

  @override
  Future<void> asyncInit(BuildContext context) async {
    basicInfoCount = (await BasicInfoMapper().selectAll()).length;
    lifeInfoCount = (await LifeInfoMapper().selectAll()).length;
    exerciseInfoCount = (await ExerciseInfoMapper().selectAll()).length;
    studyInfoCount = (await StudyInfoMapper().selectAll()).length;
    isRequesting = false;
    refresh();
  }
}

// service
class DataManagementPageService extends BaseService {
  DataManagementPageService(BuildContext context) : super(context);

  Future<void> restoreData(BuildContext context) async {
    DataManagementPageModel model =
        Provider.of<DataManagementPageModel>(context, listen: false);
    await PopMenus.sliderConfirm(
      context: context,
      function: () async {
        await SqfliteDataBase.resetTables();
        await Provider.of<DataProvider>(context, listen: false).loadData();
        model.basicInfoCount = 0;
        model.lifeInfoCount = 0;
        model.exerciseInfoCount = 0;
        model.studyInfoCount = 0;
        model..refresh();
      },
    );
  }

  Future<void> upload(BuildContext context) async {
    DataManagementPageModel model =
        Provider.of<DataManagementPageModel>(context, listen: false);
    model.isRequesting = true;
    model.refresh();
    // 关闭数据库
    await SqfliteDataBase.getInstance().close();

    String path = "${await getDatabasesPath()}/${SqfliteDataBase.dbPath}";
    Uint8List data = await new File(path).readAsBytes();
    // 上传
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    bool isSuccess = await Repository.getInstance()
        .uploadDB(context, userProvider.uid, userProvider.token, data);
    if (isSuccess) {
      await PopMenus.attention(
          context: context, content: Text(I18N.of("上传同步成功")));
    }
    // 开启数据库
    await SqfliteDataBase.init();
    model.isRequesting = false;
    model.refresh();
  }

  Future<void> download(BuildContext context) async {
    DataManagementPageModel model =
        Provider.of<DataManagementPageModel>(context, listen: false);
    model.isRequesting = true;
    model.refresh();

    // 请求
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    List<int> res = await Repository.getInstance()
        .downloadDB(context, userProvider.uid, userProvider.token);
    if (res != null) {
      // 覆盖数据
      // 关闭数据库
      await SqfliteDataBase.getInstance().close();

      String path = "${await getDatabasesPath()}/${SqfliteDataBase.dbPath}";
      File file = new File(path);
      // 删除原文件
      await file.delete();
      // 写入新文件
      await file.writeAsBytes(res);

      // 开启数据库
      await SqfliteDataBase.init();

      // 刷新数据
      await Provider.of<DataProvider>(context, listen: false).loadData();
      await model.asyncInit(context);
      await PopMenus.attention(
          context: context, content: Text(I18N.of("下载同步成功")));
    }
    model.isRequesting = false;
    model.refresh();
  }
}

// view
class _DataManagementPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DataManagementPageService service =
        Provider.of<DataManagementPageService>(context, listen: false);
    DataManagementPageModel model =
        Provider.of<DataManagementPageModel>(context, listen: true);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("数据管理")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            model.isRequesting ? LinearProgressIndicator() : Container(),
            Center(
              child: Icon(
                Icons.folder_special,
                size: 150,
                color: Theme.of(context).unselectedWidgetColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.accessibility),
              title: Text(I18N.of("基本信息")),
              trailing: Text(model.basicInfoCount.toString()),
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text(I18N.of("日常生活")),
              trailing: Text(model.lifeInfoCount.toString()),
            ),
            ListTile(
              leading: Icon(Icons.directions_bike),
              title: Text(I18N.of("体育锻炼")),
              trailing: Text(model.exerciseInfoCount.toString()),
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text(I18N.of("学习")),
              trailing: Text(model.studyInfoCount.toString()),
            ),
            Divider(),
            userProvider.token == null
                ? Container()
                : ListTile(
                    leading: Icon(Icons.cloud_upload),
                    title: Text(I18N.of("同步数据到云端")),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => service.upload(context),
                  ),
            userProvider.token == null
                ? Container()
                : ListTile(
                    leading: Icon(Icons.cloud_upload),
                    title: Text(I18N.of("从云端下载数据")),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => service.download(context),
                  ),
            ListTile(
              leading: Icon(Icons.autorenew),
              title: Text(I18N.of("重置数据")),
              trailing: Icon(Icons.chevron_right),
              onTap: () => service.restoreData(context),
            ),
          ],
        ),
      ),
    );
  }
}
