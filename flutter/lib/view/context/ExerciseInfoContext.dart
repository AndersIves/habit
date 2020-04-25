import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/database/entity/ExerciseInfo.dart';
import 'package:habit/database/entity/ScheduledExercise.dart';
import 'package:habit/database/entity/SportInfo.dart';
import 'package:habit/database/mapper/ExerciseInfoMapper.dart';
import 'package:habit/database/mapper/ScheduledExerciseMapper.dart';
import 'package:habit/database/mapper/SportInfoMapper.dart';
import 'package:habit/network/Repository.dart';
import 'package:habit/view/context/widget/BaseCard.dart';
import 'package:habit/view/context/widget/DateValueSingleLineChart.dart';
import 'package:habit/view/record/sub/AddScheduledExercisePage.dart';
import 'package:provider/provider.dart';

class ExerciseInfoContext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExerciseInfoContextService>(
            create: (_) => ExerciseInfoContextService(context)),
      ],
      child: _ExerciseInfoContextView(),
    );
  }
}

// service
class ExerciseInfoContextService extends BaseService {
  ExerciseInfoContextService(BuildContext context) : super(context);

  Future<void> cancelScheduledExercise(BuildContext context,
      MapEntry<ScheduledExercise, SportInfo> mapEntry) async {
    await PopMenus.sliderConfirm(
      context: context,
      content: Text(I18N.of("滑动来删除该条数据")),
      function: () async {
        await ScheduledExerciseMapper().delete(mapEntry.key);
        SportInfo sportInfo = new SportInfo();
        sportInfo.setId(mapEntry.value.getId());
        sportInfo.setSportTimes(mapEntry.value.getSportTimes() - 1);
        await SportInfoMapper().updateByFirstKeySelective(sportInfo);
        await Provider.of<DataProvider>(context, listen: false)
            .loadExerciseInfoData();
      },
    );
  }

  Future<void> completeScheduledExercise(BuildContext context,
      MapEntry<ScheduledExercise, SportInfo> mapEntry) async {
    await PopMenus.sliderConfirm(
      context: context,
      content: Text(I18N.of("滑动来完成计划")),
      function: () async {
        DateTime now = DateTime.now();
        ExerciseInfo exerciseInfo = new ExerciseInfo();
        exerciseInfo.setSportId(mapEntry.key.getSportId());
        exerciseInfo.setExerciseQuantity(mapEntry.key.getQuantity());
        exerciseInfo.setExerciseTime(now.millisecondsSinceEpoch);
        // 今日首次运动？
        List<ExerciseInfo> localExerciseInfo = await ExerciseInfoMapper().selectWhere(
            "exerciseTime > ${ConvertUtils.dateOfDateTime(now).millisecondsSinceEpoch}");
        if (localExerciseInfo.isEmpty){
          // 今日首次运动
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
        await ExerciseInfoMapper().insert(exerciseInfo);
        await ScheduledExerciseMapper().delete(mapEntry.key);
        await Provider.of<DataProvider>(context, listen: false)
            .loadExerciseInfoData();
      },
    );
  }

  void toAddScheduledExercisePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddScheduledExercisePage()));
  }

  void changeSizeOfExerciseInfoChartCard(BuildContext context) {
    DataProvider dataProvider =
    Provider.of<DataProvider>(context, listen: false);
    switch (dataProvider.exerciseInfoChartSize) {
      case 7:
        dataProvider.exerciseInfoChartSize = 30;
        break;
      case 30:
        dataProvider.exerciseInfoChartSize = 90;
        break;
      case 90:
        dataProvider.exerciseInfoChartSize = 7;
        break;
    }
    dataProvider.notifyListeners();

  }
}

// view
class _ExerciseInfoContextView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        overviewCard(context),
        exerciseInfoChartCard(context),
        Divider(),
        scheduledExerciseCards(context),
        addScheduledExercise(context),
      ],
    );
  }

  Widget overviewCard(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        I18N.of("最近"),
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(I18N.of("概览")),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          Icon(
            Icons.fitness_center,
            size: 100,
            color: Theme.of(context).accentColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${I18N.of("待完成计划数")}: ${dataProvider.scheduledExerciseCount}",
              ),
              Text(
                "${I18N.of("7日运动次数")}: ${dataProvider.sevenDayExerciseTimes}",
              ),
              Text(
                "${I18N.of("7日运动总消耗")}: ${dataProvider.sevenDayExerciseTotalKCal.toStringAsFixed(2)} kcal",
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }


  Widget exerciseInfoChartCard(BuildContext context) {
    ExerciseInfoContextService service =
    Provider.of<ExerciseInfoContextService>(context, listen: false);
    DataProvider dataProvider =
    Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        "${I18N.of("卡路里消耗")} (kcal)",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Container(
        height: 25,
        child: FlatButton(
          child: Text("< ${dataProvider.exerciseInfoChartSize} >"),
          onPressed: () => service.changeSizeOfExerciseInfoChartCard(context),
        ),
      ),
      child: DateValueSingleLineChart(
        size: dataProvider.exerciseInfoChartSize,
        sports: dataProvider.exerciseInfoFlSpots,
      ),
    );
  }

  Widget addScheduledExercise(BuildContext context) {
    ExerciseInfoContextService service =
        Provider.of<ExerciseInfoContextService>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: RaisedButton(
        color: Theme.of(context).accentColor,
        textColor: Theme.of(context).cardColor,
        child: Text(I18N.of("添加计划任务")),
        onPressed: () => service.toAddScheduledExercisePage(context),
      ),
    );
  }

  Widget scheduledExerciseCards(BuildContext context) {
    ExerciseInfoContextService service =
        Provider.of<ExerciseInfoContextService>(context, listen: false);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return Column(
      children: dataProvider.scheduledExerciseSportInfoList.map((i) {
        return BaseCard(
          title: Text(I18N.of("计划任务"),
            style: Theme.of(context).textTheme.title,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Icon(
                Icons.timer,
                size: 100,
                color: Theme.of(context).accentColor,
              ),
              Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${I18N.of("运动类型")}: ${i.value.getName()}"),
                  Text(
                      "${I18N.of("运动时长")}: ${ConvertUtils.fixedDouble(i.key.getQuantity() * 60, 2)} min"),
                  Text("${I18N.of("消耗")}: ${i.value.getHkCalorie()} h/kcal"),
                  Text(
                      "${I18N.of("预计消耗")}: ${ConvertUtils.fixedDouble(i.key.getQuantity() * i.value.getHkCalorie(), 2)} kcal"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).cardColor,
                        child: Text(I18N.of("取消")),
                        onPressed: () =>
                            service.cancelScheduledExercise(context, i),
                      ),
                      Container(
                        width: 10,
                      ),
                      RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).cardColor,
                        child: Text(I18N.of("完成")),
                        onPressed: () =>
                            service.completeScheduledExercise(context, i),
                      ),
                    ],
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
