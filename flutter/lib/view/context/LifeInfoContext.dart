import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/view/context/widget/BaseCard.dart';
import 'package:habit/view/context/widget/DateTimeMultiLineChart.dart';
import 'package:habit/view/context/widget/DateValueSingleLineChart.dart';
import 'package:provider/provider.dart';

class LifeInfoContext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LifeInfoContextService>(
            create: (_) => LifeInfoContextService(context)),
      ],
      child: _LifeInfoContextView(),
    );
  }
}

// service
class LifeInfoContextService extends BaseService {
  LifeInfoContextService(BuildContext context) : super(context);

  void changeSizeOfSleepTimeChartCard(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    switch (dataProvider.sleepTimeChartSize) {
      case 7:
        dataProvider.sleepTimeChartSize = 30;
        break;
      case 30:
        dataProvider.sleepTimeChartSize = 90;
        break;
      case 90:
        dataProvider.sleepTimeChartSize = 7;
        break;
    }
    dataProvider.notifyListeners();
  }

  changeSizeOfInjectKCalChartSize(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    switch (dataProvider.injectKCalChartSize) {
      case 7:
        dataProvider.injectKCalChartSize = 30;
        break;
      case 30:
        dataProvider.injectKCalChartSize = 90;
        break;
      case 90:
        dataProvider.injectKCalChartSize = 7;
        break;
    }
    dataProvider.notifyListeners();
  }

  changeSizeOfProgressChartSize(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    switch (dataProvider.progressChartSize) {
      case 7:
        dataProvider.progressChartSize = 30;
        break;
      case 30:
        dataProvider.progressChartSize = 90;
        break;
      case 90:
        dataProvider.progressChartSize = 7;
        break;
    }
    dataProvider.notifyListeners();
  }

  void changeSizeOfTimeChartCard(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    switch (dataProvider.timeChartSize) {
      case 7:
        dataProvider.timeChartSize = 30;
        break;
      case 30:
        dataProvider.timeChartSize = 90;
        break;
      case 90:
        dataProvider.timeChartSize = 7;
        break;
    }
    dataProvider.notifyListeners();
  }

  void changeSizeOfMoneyChartSize(BuildContext context) {
    DataProvider dataProvider =
    Provider.of<DataProvider>(context, listen: false);
    switch (dataProvider.moneyChartSize) {
      case 7:
        dataProvider.moneyChartSize = 30;
        break;
      case 30:
        dataProvider.moneyChartSize = 90;
        break;
      case 90:
        dataProvider.moneyChartSize = 7;
        break;
    }
    dataProvider.notifyListeners();
  }

  void changeSizeOfEatTimeChartCard(BuildContext context) {
    DataProvider dataProvider =
    Provider.of<DataProvider>(context, listen: false);
    switch (dataProvider.eatTimeChartSize) {
      case 7:
        dataProvider.eatTimeChartSize = 30;
        break;
      case 30:
        dataProvider.eatTimeChartSize = 90;
        break;
      case 90:
        dataProvider.eatTimeChartSize = 7;
        break;
    }
    dataProvider.notifyListeners();}
}

// view
class _LifeInfoContextView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LifeInfoContextService service =
        Provider.of<LifeInfoContextService>(context, listen: false);
    return ListView(
      children: <Widget>[
        overviewCard(context),
        sleepTimeChartCard(context),
        injectKCalChartCard(context),
        moneyChartCard(context),
        timeChartCard(context),
        eatTimeChartCard(context),
        progressChartCard(context),
      ],
    );
  }

  Widget overviewCard(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        I18N.of("今日"),
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(I18N.of("概览")),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          Icon(
            Icons.wb_sunny,
            size: 100,
            color: Theme.of(context).accentColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${I18N.of("昨夜睡眠时长")}: ${dataProvider.lastNightSleepTime == null ? I18N.of("无数据") : ConvertUtils.fixedDouble(ConvertUtils.hourFormMilliseconds(dataProvider.lastNightSleepTime), 2)} h",
              ),
              Text(
                "${I18N.of("摄入卡路里总量")}: ${dataProvider.todayInjectKCal.toStringAsFixed(2)} kcal",
              ),
              Text(
                "${I18N.of("消费")}: ${ConvertUtils.fixedDouble(dataProvider.todayMoney, 2)}",
              ),
              Text(
                "${I18N.of("打卡完成度")}: ${ConvertUtils.fixedDouble(dataProvider.todayProgress / 12, 2)}",
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }

  Widget sleepTimeChartCard(BuildContext context) {
    LifeInfoContextService service =
        Provider.of<LifeInfoContextService>(context, listen: false);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        "${I18N.of("睡眠时长")} (h)",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Container(
        height: 25,
        child: FlatButton(
          child: Text("< ${dataProvider.sleepTimeChartSize} >"),
          onPressed: () => service.changeSizeOfSleepTimeChartCard(context),
        ),
      ),
      child: DateValueSingleLineChart(
        size: dataProvider.sleepTimeChartSize,
        sports: dataProvider.sleepTimeFlSpots,
        isEndYesterday: true,
      ),
    );
  }

  Widget injectKCalChartCard(BuildContext context) {
    LifeInfoContextService service =
        Provider.of<LifeInfoContextService>(context, listen: false);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        "${I18N.of("摄入卡路里")} (kcal)",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Container(
        height: 25,
        child: FlatButton(
          child: Text("< ${dataProvider.injectKCalChartSize} >"),
          onPressed: () => service.changeSizeOfInjectKCalChartSize(context),
        ),
      ),
      child: DateValueSingleLineChart(
        size: dataProvider.injectKCalChartSize,
        sports: dataProvider.injectKCalFlSpots,
      ),
    );
  }

  Widget moneyChartCard(BuildContext context) {
    LifeInfoContextService service =
    Provider.of<LifeInfoContextService>(context, listen: false);
    DataProvider dataProvider =
    Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        "${I18N.of("花费记录")}",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Container(
        height: 25,
        child: FlatButton(
          child: Text("< ${dataProvider.moneyChartSize} >"),
          onPressed: () => service.changeSizeOfMoneyChartSize(context),
        ),
      ),
      child: DateValueSingleLineChart(
        size: dataProvider.moneyChartSize,
        sports: dataProvider.moneyFlSpots,
      ),
    );
  }

  Widget progressChartCard(BuildContext context) {
    LifeInfoContextService service =
        Provider.of<LifeInfoContextService>(context, listen: false);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        "${I18N.of("每日打卡完成度")}",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Container(
        height: 25,
        child: FlatButton(
          child: Text("< ${dataProvider.progressChartSize} >"),
          onPressed: () => service.changeSizeOfProgressChartSize(context),
        ),
      ),
      child: DateValueSingleLineChart(
        size: dataProvider.progressChartSize,
        sports: dataProvider.progressFlSpots,
      ),
    );
  }

  Widget timeChartCard(BuildContext context) {
    LifeInfoContextService service =
        Provider.of<LifeInfoContextService>(context, listen: false);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        "${I18N.of("睡眠时间")}",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Container(
        height: 25,
        child: FlatButton(
          child: Text("< ${dataProvider.timeChartSize} >"),
          onPressed: () => service.changeSizeOfTimeChartCard(context),
        ),
      ),
      child: DateTimeMultiLineChart(
        size: dataProvider.timeChartSize,
        lineNameSportsMap: {
          I18N.of("起床时间"): dataProvider.getUpTimeFlSpots,
          I18N.of("午休时间"): dataProvider.midRestTimeFlSpots,
          I18N.of("睡觉时间"): dataProvider.restTimeFlSpots
        },
      ),
    );
  }

  Widget eatTimeChartCard(BuildContext context) {
    LifeInfoContextService service =
    Provider.of<LifeInfoContextService>(context, listen: false);
    DataProvider dataProvider =
    Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        "${I18N.of("吃饭时间")}",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Container(
        height: 25,
        child: FlatButton(
          child: Text("< ${dataProvider.eatTimeChartSize} >"),
          onPressed: () => service.changeSizeOfEatTimeChartCard(context),
        ),
      ),
      child: DateTimeMultiLineChart(
        size: dataProvider.eatTimeChartSize,
        lineNameSportsMap: {
          I18N.of("早饭时间"): dataProvider.eatBreakfastTimeFlSpots,
          I18N.of("午饭时间"): dataProvider.eatLunchTimeFlSpots,
          I18N.of("晚饭时间"): dataProvider.eatDinnerTimeFlSpots
        },
      ),
    );
  }

}
