import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/database/entity/StudyInfo.dart';
import 'package:habit/database/mapper/StudyInfoMapper.dart';
import 'package:habit/network/Repository.dart';
import 'package:provider/provider.dart';

class StudyInfoRecordingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StudyInfoRecordingPageService>(
            create: (_) => StudyInfoRecordingPageService(context)),
        ChangeNotifierProvider<StudyInfoRecordingPageModel>(
            create: (_) => StudyInfoRecordingPageModel(context)),
      ],
      child: _StudyInfoRecordingPageView(),
    );
  }
}

// model
class StudyInfoRecordingPageModel extends BaseModel {
  StudyInfoRecordingPageModel(BuildContext context) : super(context);

  TextEditingController courseNameController;

  int isLate;
  int isAbsent;
  int isHomeWorkDone;
  TextEditingController homeWorkController;
  int difficulty;
  TextEditingController troubleController;

  @override
  void init(BuildContext context) {
    // TODO: implement init
    super.init(context);
    courseNameController = new TextEditingController();
    isLate = 0;
    isAbsent = 0;
    isHomeWorkDone = 1;
    homeWorkController = new TextEditingController();
    difficulty = 0;
    troubleController = new TextEditingController();
  }
}

// service
class StudyInfoRecordingPageService extends BaseService {
  StudyInfoRecordingPageService(BuildContext context) : super(context);

  void setIsLate(BuildContext context, int i) {
    StudyInfoRecordingPageModel model =
        Provider.of<StudyInfoRecordingPageModel>(context, listen: false);
    model.isLate = i;
    if (i == 0) {
      model.isAbsent = 0;
    }
    model.refresh();
  }

  void setIsAbsent(BuildContext context, int i) {
    StudyInfoRecordingPageModel model =
        Provider.of<StudyInfoRecordingPageModel>(context, listen: false);
    model.isAbsent = i;
    if (i == 1) {
      model.isLate = 1;
    }
    model.refresh();
  }

  void setIsHomeWorkDone(BuildContext context, int i) {
    StudyInfoRecordingPageModel model =
        Provider.of<StudyInfoRecordingPageModel>(context, listen: false);
    model.isHomeWorkDone = i;
    model.refresh();
  }

  void setDifficulty(BuildContext context, int i) {
    StudyInfoRecordingPageModel model =
        Provider.of<StudyInfoRecordingPageModel>(context, listen: false);
    model.difficulty = i;
    model.refresh();
  }

  void preview(BuildContext context) {
    StudyInfoRecordingPageModel model =
        Provider.of<StudyInfoRecordingPageModel>(context, listen: false);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(I18N.of("MarkDown预览")),
              ),
              body: Markdown(
                data: model.troubleController.text.toString(),
              ),
            )));
  }

  Future<void> record(BuildContext context) async {
    StudyInfoRecordingPageModel model =
        Provider.of<StudyInfoRecordingPageModel>(context, listen: false);
    if (model.courseNameController.text.trim().isEmpty) {
      await PopMenus.attention(context: context,content: Text(I18N.of("课程主题不能为空")));
      return;
    }
    DateTime now = DateTime.now();
    StudyInfo studyInfo = new StudyInfo();
    studyInfo.setDate(now.millisecondsSinceEpoch);
    studyInfo.setCourseName(model.courseNameController.text);
    studyInfo.setIsLate(model.isLate);
    studyInfo.setIsAbsent(model.isAbsent);
    studyInfo.setIsHomeWorkDone(model.isHomeWorkDone);
    if (model.isHomeWorkDone == 0) {
      studyInfo.setHomeworks(model.homeWorkController.text);
    }
    studyInfo.setDifficulty(model.difficulty);
    studyInfo.setIsTroublesSolved(1);
    if (model.difficulty == 2) {
      studyInfo.setIsTroublesSolved(0);
      studyInfo.setTroubles(model.troubleController.text);
    }

    // 今日首次？
    List<StudyInfo> localStudyInfo = await StudyInfoMapper().selectWhere(
        "date > ${ConvertUtils.dateOfDateTime(now).millisecondsSinceEpoch}");
    if (localStudyInfo.isEmpty){
      // 今日首次
      // 增加金币
      UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
      if (userProvider.token != null) {
        int increasedCoin = await Repository.getInstance()
            .increaseCoin(context, userProvider.uid, userProvider.token);
        if (increasedCoin != null) {
          await PopMenus.coinAdd(
              context: context, addedCoins: increasedCoin);
          userProvider.coins += increasedCoin;
          userProvider.refresh();
        }
      }
    }

    // 插入
    await StudyInfoMapper().insert(studyInfo);
    await Provider.of<DataProvider>(context,listen: false).loadStudyInfoData();
    Navigator.of(context).pop();
  }
}

// view
class _StudyInfoRecordingPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StudyInfoRecordingPageService service =
        Provider.of<StudyInfoRecordingPageService>(context, listen: false);
    StudyInfoRecordingPageModel model =
        Provider.of<StudyInfoRecordingPageModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("记录课程学习")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                controller: model.courseNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: I18N.of("课程主题"),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(I18N.of("是否迟到")),
                Row(
                  children: [I18N.of("是"), 1, I18N.of("否"), 0].map((i) {
                    if (i is int) {
                      return Radio<int>(
                        value: i,
                        groupValue: model.isLate,
                        onChanged: (i) => service.setIsLate(context, i),
                      );
                    } else if (i is String) {
                      return Text(i);
                    }
                    return Container();
                  }).toList(),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(I18N.of("是否缺席")),
                Row(
                  children: [I18N.of("是"), 1, I18N.of("否"), 0].map((i) {
                    if (i is int) {
                      return Radio<int>(
                        value: i,
                        groupValue: model.isAbsent,
                        onChanged: (i) => service.setIsAbsent(context, i),
                      );
                    } else if (i is String) {
                      return Text(i);
                    }
                    return Container();
                  }).toList(),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(I18N.of("作业是否完成")),
                Row(
                  children: [I18N.of("是"), 1, I18N.of("否"), 0].map((i) {
                    if (i is int) {
                      return Radio<int>(
                        value: i,
                        groupValue: model.isHomeWorkDone,
                        onChanged: (i) => service.setIsHomeWorkDone(context, i),
                      );
                    } else if (i is String) {
                      return Text(i);
                    }
                    return Container();
                  }).toList(),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                enabled: model.isHomeWorkDone == 0,
                maxLines: model.isHomeWorkDone == 0 ? 5 : 1,
                controller: model.homeWorkController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: I18N.of("未完成的作业"),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(I18N.of("课程难度")),
                Row(
                  children: [
                    I18N.of("简单"),
                    0,
                    I18N.of("一般"),
                    1,
                    I18N.of("困难"),
                    2
                  ].map((i) {
                    if (i is int) {
                      return Radio<int>(
                        value: i,
                        groupValue: model.difficulty,
                        onChanged: (i) => service.setDifficulty(context, i),
                      );
                    } else if (i is String) {
                      return Text(i);
                    }
                    return Container();
                  }).toList(),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Stack(
                children: <Widget>[
                  TextFormField(
                    enabled: model.difficulty == 2,
                    maxLines: model.difficulty == 2 ? 5 : 1,
                    controller: model.troubleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: I18N.of("遇到的问题"),
                      hintText: I18N.of("支持MarkDown"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.zoom_out_map,
                          color: model.difficulty != 2
                              ? null
                              : Theme.of(context).accentColor,
                        ),
                        onPressed: model.difficulty != 2
                            ? null
                            : () => service.preview(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).cardColor,
              child: Text(I18N.of("记录")),
              onPressed: () => service.record(context),
            ),
          ],
        ),
      ),
    );
  }
}
