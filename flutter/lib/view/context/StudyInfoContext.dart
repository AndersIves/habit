import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/database/entity/StudyInfo.dart';
import 'package:habit/view/context/widget/BaseCard.dart';
import 'package:habit/view/context/widget/DateValueSingleLineChart.dart';
import 'package:habit/view/context/widget/StudyInfoDetailsPage.dart';
import 'package:provider/provider.dart';

class StudyInfoContext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StudyInfoContextService>(
            create: (_) => StudyInfoContextService(context)),
      ],
      child: _StudyInfoContextView(),
    );
  }
}

// service
class StudyInfoContextService extends BaseService {
  StudyInfoContextService(BuildContext context) : super(context);

  void changeSizeOfBwhChartCard(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    switch (dataProvider.dailyStudyCountChartSize) {
      case 7:
        dataProvider.dailyStudyCountChartSize = 30;
        break;
      case 30:
        dataProvider.dailyStudyCountChartSize = 90;
        break;
      case 90:
        dataProvider.dailyStudyCountChartSize = 7;
        break;
    }
    dataProvider.notifyListeners();
  }

  Future<void> toStudyInfoDetailsPage(BuildContext context, StudyInfo studyInfo) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>StudyInfoDetailsPage(studyInfo)));
  }

}

// view
class _StudyInfoContextView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        overviewCard(context),
        dailyStudyCountChart(context),
        Divider(),
        unSolveStudyInfoCards(context),
      ],
    );
  }

  Widget overviewCard(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        I18N.of("总结"),
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(I18N.of("概览")),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          Icon(
            Icons.edit,
            size: 100,
            color: Theme.of(context).accentColor,
          ),
          Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${I18N.of("迟到次数")}: ${dataProvider.lateTimes}",
              ),
              Text(
                "${I18N.of("缺席次数")}: ${dataProvider.absentTimes}",
              ),
              Text(
                "${I18N.of("未解决的问题数")}: ${dataProvider.unSolveTroubles}",
              ),
              Text(
                "${I18N.of("未完成的作业数")}: ${dataProvider.unDoneHomeWorks}",
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }

  Widget dailyStudyCountChart(BuildContext context) {
    StudyInfoContextService service =
        Provider.of<StudyInfoContextService>(context, listen: false);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        "${I18N.of("每日课程数")}",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Container(
        height: 25,
        child: FlatButton(
          child: Text("< ${dataProvider.dailyStudyCountChartSize} >"),
          onPressed: () => service.changeSizeOfBwhChartCard(context),
        ),
      ),
      child: DateValueSingleLineChart(
        size: dataProvider.dailyStudyCountChartSize,
        sports: dataProvider.dailyStudyCountFlSpots,
      ),
    );
  }

  Widget unSolveStudyInfoCards(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    StudyInfoContextService service =
    Provider.of<StudyInfoContextService>(context, listen: false);
    return Column(
      children: dataProvider.unSolveStudyInfoList.map((i) {
        return BaseCard(
          title: Text(
            i.getCourseName(),
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(DateTime.fromMillisecondsSinceEpoch(i.getDate())
              .toString()
              .substring(0, 16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Icon(
                Icons.info_outline,
                size: 100,
                color: Theme.of(context).accentColor,
              ),
              Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  i.getIsHomeWorkDone() == 1
                      ? Container()
                      : Text(
                          I18N.of("有未完成的作业"),
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                  i.getIsTroublesSolved() == 1
                      ? Container()
                      : Text(
                          I18N.of("有未解决的问题"),
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),

                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).cardColor,
                    child: Text(I18N.of("详情")),
                    onPressed: () => service.toStudyInfoDetailsPage(context, i),
                  ),
                ],
              ),
              Container(),
            ],
          ),
        );
      }).toList(),
    );
  }
}
