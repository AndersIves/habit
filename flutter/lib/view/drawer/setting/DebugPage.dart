import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit/common/SqfliteDataBase.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/NotificationProvider.dart';
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
import 'package:provider/provider.dart';

class DebugPage extends StatefulWidget {
  @override
  _DebugPageState createState() => _DebugPageState();
}

class Debug {
  final String name;
  final Function function;

  Debug(this.name, this.function);

}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    NotificationProvider notificationProvider = Provider.of<NotificationProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("debug"),
      ),
      body: ListView(
        children: <Debug>[
          Debug("测试数据", () => _test(context)),
          Debug("测试普通通知", () {
            notificationProvider.notice(10, "123", "123");
          }),
          Debug("调度通知 id 10", () {
            notificationProvider.scheduledNotice(10, "123", "123",22,43,20);
          }),
          Debug("取消通知 id 10", () {
            notificationProvider.cancel(10);
          }),
          Debug("通知列表", () async {
            List<PendingNotificationRequest> l = await notificationProvider.getNotifications();
            for (PendingNotificationRequest value in l) {
              debugPrint("${value.id} ${value.title} ${value.body}");
            }
          }),
        ].map((i) {
          return ListTile(
            title: Text(i.name),
            onTap: i.function,
          );
        }).toList(),
      ),
    );
  }
}

Future<void> _test(BuildContext context) async {
  await SqfliteDataBase.resetTables();
  Random random = Random();
  for (int i = 1; i <= 10; i++) {
    FoodInfo foodInfo = FoodInfo();
    foodInfo.setName("food_$i");
    foodInfo.setHgkCalorie(
        double.parse(((i * 10 + random.nextDouble())).toStringAsFixed(2)));
    foodInfo.setEatTimes(0);
    await FoodInfoMapper().insert(foodInfo);

    SportInfo sportInfo = SportInfo();
    sportInfo.setName("spot_$i");
    sportInfo.setHkCalorie(
        double.parse(((i * 10 + random.nextDouble())).toStringAsFixed(2)));
    sportInfo.setSportTimes(0);
    await SportInfoMapper().insert(sportInfo);
  }
  for (int i = 99; i >= 0; i--) {
    BasicInfo basicInfo = new BasicInfo();
    basicInfo.setDate(
        DateTime.now().subtract(Duration(days: i)).millisecondsSinceEpoch);
    basicInfo.setHeight(
        double.parse(((170 + random.nextDouble())).toStringAsFixed(2)));
    basicInfo.setWeight(
        double.parse(((60 + random.nextDouble())).toStringAsFixed(2)));
    basicInfo.setWaistLine(
        (double.parse(((88 + random.nextDouble())).toStringAsFixed(2))));
    basicInfo.setBreastLine(
        (double.parse(((88 + random.nextDouble())).toStringAsFixed(2))));
    basicInfo.setHipLine(
        (double.parse(((94 + random.nextDouble())).toStringAsFixed(2))));
    await BasicInfoMapper().insert(basicInfo);

    LifeInfo lifeInfo = new LifeInfo();
    DateTime thatDay = DateTime.now().subtract(Duration(days: i));
    DateTime thatDayZeroTime =
    DateTime(thatDay.year, thatDay.month, thatDay.day);
    lifeInfo.setDate(thatDay.millisecondsSinceEpoch);
    lifeInfo.setGetUpTime(thatDayZeroTime
        .add(Duration(hours: 6, minutes: 50))
        .millisecondsSinceEpoch +
        random.nextInt(30) * 60000);

    lifeInfo.setBreakfastTime(thatDayZeroTime
        .add(Duration(hours: 7, minutes: 50))
        .millisecondsSinceEpoch +
        random.nextInt(30) * 60000);
    lifeInfo.setBreakfastQuantity(100 + 10 * random.nextDouble());
    lifeInfo.setBreakfastId(1 + random.nextInt(9));
    lifeInfo.setBreakfastMoney((1 + random.nextInt(9)).toDouble());

    lifeInfo.setLunchTime(thatDayZeroTime
        .add(Duration(hours: 12, minutes: 50))
        .millisecondsSinceEpoch +
        random.nextInt(30) * 60000);
    lifeInfo.setLunchQuantity(100 + 10 * random.nextDouble());
    lifeInfo.setLunchId(1 + random.nextInt(9));
    lifeInfo.setLunchMoney((1 + random.nextInt(9)).toDouble());

    lifeInfo.setMidRestTime(
        thatDayZeroTime.add(Duration(hours: 13)).millisecondsSinceEpoch +
            random.nextInt(30 * 60000));

    lifeInfo.setDinnerTime(
        thatDayZeroTime.add(Duration(hours: 18)).millisecondsSinceEpoch +
            random.nextInt(30 * 60000));
    lifeInfo.setDinnerQuantity(100 + 10 * random.nextDouble());
    lifeInfo.setDinnerId(1 + random.nextInt(9));
    lifeInfo.setDinnerMoney((1 + random.nextInt(9)).toDouble());

    lifeInfo.setRestTime(
        thatDayZeroTime.add(Duration(hours: 21)).millisecondsSinceEpoch +
            random.nextInt(30 * 60000));

    await LifeInfoMapper().insert(lifeInfo);

    ExerciseInfo exerciseInfo = new ExerciseInfo();
    exerciseInfo.setSportId(1 + random.nextInt(9));
    exerciseInfo.setExerciseQuantity(100 + 10 * random.nextDouble());
    exerciseInfo.setExerciseTime(thatDayZeroTime
        .add(Duration(hours: 12, minutes: 50))
        .millisecondsSinceEpoch +
        random.nextInt(30) * 60000);
    await ExerciseInfoMapper().insert(exerciseInfo);
  }
  await Provider.of<DataProvider>(context, listen: false).loadData();
}