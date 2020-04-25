import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/database/entity/StudyInfo.dart';
import 'package:habit/database/mapper/StudyInfoMapper.dart';
import 'package:provider/provider.dart';

class StudyInfoDetailsPage extends StatelessWidget {
  final StudyInfo studyInfo;

  StudyInfoDetailsPage(this.studyInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("课程学习详情")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Text(
              studyInfo.getCourseName(),
              style: Theme.of(context).textTheme.title,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(I18N.of("是否迟到")),
                Row(
                  children: [I18N.of("是"), 1, I18N.of("否"), 0].map((i) {
                    if (i is int) {
                      return Radio<int>(
                        value: i,
                        groupValue: studyInfo.getIsLate(),
                        onChanged: null,
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
                        groupValue: studyInfo.getIsAbsent(),
                        onChanged: null,
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
                        groupValue: studyInfo.getIsHomeWorkDone(),
                        onChanged: null,
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
                        groupValue: studyInfo.getDifficulty(),
                        onChanged: null,
                      );
                    } else if (i is String) {
                      return Text(i);
                    }
                    return Container();
                  }).toList(),
                )
              ],
            ),
            studyInfo.getIsHomeWorkDone() == 1
                ? Container()
                : Column(
                    children: <Widget>[
                      Divider(),
                      TextField(
                        maxLines: 5,
                        readOnly: true,
                        controller: TextEditingController(
                            text: studyInfo.getHomeworks()),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: I18N.of("未完成的作业"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).cardColor,
                            child: Text(I18N.of("已解决")),
                            onPressed: () => solveHomeWork(context),
                          ),
                        ],
                      ),
                    ],
                  ),
            studyInfo.getIsTroublesSolved() == 1
                ? Container()
                : Column(
                    children: <Widget>[
                      Divider(),
                      TextFormField(
                        maxLines: 5,
                        readOnly: true,
                        controller: TextEditingController(
                            text: studyInfo.getTroubles()),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: I18N.of("遇到的问题"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).cardColor,
                            child: Text(I18N.of("已解决")),
                            onPressed: () => solveTroubles(context),
                          ),
                        ],
                      ),
                    ],
                  ),
            Divider(),
            Center(
              child: Text(
                DateTime.fromMillisecondsSinceEpoch(studyInfo.getDate())
                    .toString()
                    .substring(0, 16),
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> solveTroubles(BuildContext context) async {
    StudyInfo s = new StudyInfo();
    s.setId(studyInfo.getId());
    s.setIsTroublesSolved(1);
    await StudyInfoMapper().updateByFirstKeySelective(s);
    await Provider.of<DataProvider>(context, listen: false).loadStudyInfoData();
    Navigator.of(context).pop();
  }

  Future<void> solveHomeWork(BuildContext context) async {
    StudyInfo s = new StudyInfo();
    s.setId(studyInfo.getId());
    s.setIsHomeWorkDone(1);
    await StudyInfoMapper().updateByFirstKeySelective(s);
    await Provider.of<DataProvider>(context, listen: false).loadStudyInfoData();
    Navigator.of(context).pop();
  }
}
