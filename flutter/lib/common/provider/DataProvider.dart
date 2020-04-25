import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habit/common/provider/ConfigProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/common/utils/VerificationUtils.dart';
import 'package:habit/database/entity/BasicInfo.dart';
import 'package:habit/database/entity/ExerciseInfo.dart';
import 'package:habit/database/entity/FoodInfo.dart';
import 'package:habit/database/entity/LifeInfo.dart';
import 'package:habit/database/entity/ScheduledExercise.dart';
import 'package:habit/database/entity/SportInfo.dart';
import 'package:habit/database/entity/StudyInfo.dart';
import 'package:habit/database/mapper/BasicInfoMapper.dart';
import 'package:habit/database/mapper/ExerciseInfoMapper.dart';
import 'package:habit/database/mapper/FoodInfoMapper.dart';
import 'package:habit/database/mapper/LifeInfoMapper.dart';
import 'package:habit/database/mapper/ScheduledExerciseMapper.dart';
import 'package:habit/database/mapper/SportInfoMapper.dart';
import 'package:habit/database/mapper/StudyInfoMapper.dart';

class DataProvider extends ChangeNotifier {
  Future<void> init() async {
    await loadData();

    DateTime now = DateTime.now();
    Timer.periodic(
        ConvertUtils.dateOfDateTime(now)
            .add(Duration(days: 1, seconds: 1))
            .difference(now), (t) async {
      t.cancel();
      debugPrint("refresh");
      await loadData();
      Timer.periodic(Duration(days: 1), (t) async {
        debugPrint("refresh");
        await loadData();
      });
    });

    debugPrint("init DataProvider");
  }

  Future<void> loadData() async {
    await loadBasicInfoData();
    await loadLifeInfoData();
    await loadExerciseInfoData();
    await loadStudyInfoData();
    await evaluateToday();
  }

  // basic info
  double height;
  double weight;
  String bmi;

  double breastLine;
  double waistLine;
  double hipLine;

  List<FlSpot> weightFlSpots = [];
  int weightChartSize = 7;

  List<FlSpot> brestLineFlSpots = [];
  List<FlSpot> waistLineFlSpots = [];
  List<FlSpot> hipLineFlSpots = [];
  int bwhChartSize = 7;

  Future<void> loadBasicInfoData() async {
    int dateTime90daysAgo = ConvertUtils.dateOfDateTime(DateTime.now())
        .subtract(Duration(days: 90))
        .millisecondsSinceEpoch;
    // 基本信息
    List<BasicInfo> basicInfoList =
        await BasicInfoMapper().selectWhere("date >= $dateTime90daysAgo");
    height = null;
    weight = null;
    bmi = null;
    breastLine = null;
    waistLine = null;
    hipLine = null;
    // 基本数据
    if (basicInfoList.isNotEmpty) {
      height = basicInfoList.last.getHeight();
      weight = basicInfoList.last.getWeight();
      bmi = (weight / height / height * 10000).toStringAsFixed(2);
      breastLine = basicInfoList.last.getBreastLine();
      waistLine = basicInfoList.last.getWaistLine();
      hipLine = basicInfoList.last.getHipLine();
    }
    // 将数据转为点
    weightFlSpots = [];

    brestLineFlSpots = [];
    waistLineFlSpots = [];
    hipLineFlSpots = [];
    basicInfoList.forEach((i) {
      // 换算为x.x天
      weightFlSpots.add(
        FlSpot(
          ConvertUtils.localDaysSinceEpoch(
                  DateTime.fromMillisecondsSinceEpoch(i.getDate()))
              .floorToDouble(),
          i.getWeight(),
        ),
      );
      brestLineFlSpots.add(
        FlSpot(
          ConvertUtils.localDaysSinceEpoch(
                  DateTime.fromMillisecondsSinceEpoch(i.getDate()))
              .floorToDouble(),
          i.getBreastLine(),
        ),
      );
      waistLineFlSpots.add(
        FlSpot(
          ConvertUtils.localDaysSinceEpoch(
                  DateTime.fromMillisecondsSinceEpoch(i.getDate()))
              .floorToDouble(),
          i.getWaistLine(),
        ),
      );
      hipLineFlSpots.add(
        FlSpot(
          ConvertUtils.localDaysSinceEpoch(
                  DateTime.fromMillisecondsSinceEpoch(i.getDate()))
              .floorToDouble(),
          i.getHipLine(),
        ),
      );
    });

    notifyListeners();
  }

  // life info
  int lastNightSleepTime;
  double todayInjectKCal = 0;
  int todayProgress = 0;
  double todayMoney = 0;

  List<FlSpot> sleepTimeFlSpots = [];
  int sleepTimeChartSize = 7;

  List<FlSpot> injectKCalFlSpots = [];
  int injectKCalChartSize = 7;

  List<FlSpot> getUpTimeFlSpots = [];
  List<FlSpot> midRestTimeFlSpots = [];
  List<FlSpot> restTimeFlSpots = [];
  int timeChartSize = 7;

  List<FlSpot> progressFlSpots = [];
  int progressChartSize = 7;

  List<FlSpot> moneyFlSpots = [];
  int moneyChartSize = 7;

  List<FlSpot> eatBreakfastTimeFlSpots = [];
  List<FlSpot> eatLunchTimeFlSpots = [];
  List<FlSpot> eatDinnerTimeFlSpots = [];
  int eatTimeChartSize = 7;

  Future<void> loadLifeInfoData() async {
    int date91daysAgo = ConvertUtils.dateOfDateTime(DateTime.now())
        .subtract(Duration(days: 91))
        .millisecondsSinceEpoch;
    // 日常生活
    List<LifeInfo> lifeInfoList =
        await LifeInfoMapper().selectWhere("date >= $date91daysAgo");
    List<FoodInfo> foodInfoList = await FoodInfoMapper().selectAll();

    // 构造点、数据
    sleepTimeFlSpots = [];
    injectKCalFlSpots = [];
    progressFlSpots = [];
    getUpTimeFlSpots = [];
    midRestTimeFlSpots = [];
    restTimeFlSpots = [];
    moneyFlSpots = [];
    eatBreakfastTimeFlSpots = [];
    eatLunchTimeFlSpots = [];
    eatDinnerTimeFlSpots = [];
    todayInjectKCal = 0;
    todayProgress = 0;
    todayMoney = 0;
    lastNightSleepTime = null;
    if (lifeInfoList.isNotEmpty) {
      for (int i = 0; i < lifeInfoList.length; i++) {
        LifeInfo lastLifeInfo = i == 0 ? new LifeInfo() : lifeInfoList[i - 1];
        LifeInfo currLifeInfo = lifeInfoList[i];
        // 准备数据
        int date = currLifeInfo.getDate();
        int lastDate = lastLifeInfo.getDate();
        int sleepTime;
        if (lastLifeInfo.getRestTime() != null &&
            currLifeInfo.getGetUpTime() != null) {
          sleepTime = currLifeInfo.getGetUpTime() - lastLifeInfo.getRestTime();
        }
        lastNightSleepTime = sleepTime;
        double totalCal = 0;
        if (currLifeInfo.getBreakfastQuantity() != null) {
          FoodInfo currBreakfastInfo = foodInfoList.firstWhere(
              (test) => test.getId() == currLifeInfo.getBreakfastId());
          totalCal += currBreakfastInfo.getHgkCalorie() *
              currLifeInfo.getBreakfastQuantity();
        }
        if (currLifeInfo.getLunchQuantity() != null) {
          FoodInfo currLunchInfo = foodInfoList
              .firstWhere((test) => test.getId() == currLifeInfo.getLunchId());
          totalCal +=
              currLunchInfo.getHgkCalorie() * currLifeInfo.getLunchQuantity();
        }
        if (currLifeInfo.getDinnerQuantity() != null) {
          FoodInfo currDinnerInfo = foodInfoList
              .firstWhere((test) => test.getId() == currLifeInfo.getDinnerId());
          totalCal +=
              currDinnerInfo.getHgkCalorie() * currLifeInfo.getDinnerQuantity();
        }
        todayInjectKCal = totalCal;
        int progress = 0;
        ConfigProvider configProvider = new ConfigProvider();
        configProvider.load();
        progress += currLifeInfo.getGetUpTime() == null
            ? 0
            : VerifyUtils.isBetweenTime(configProvider.getUpTimeStart,
                    currLifeInfo.getGetUpTime(), configProvider.getUpTimeEnd)
                ? 2
                : 1;
        progress += currLifeInfo.getBreakfastTime() == null
            ? 0
            : VerifyUtils.isBetweenTime(
                    configProvider.breakfastTimeStart,
                    currLifeInfo.getBreakfastTime(),
                    configProvider.breakfastTimeEnd)
                ? 2
                : 1;
        progress += currLifeInfo.getLunchTime() == null
            ? 0
            : VerifyUtils.isBetweenTime(configProvider.lunchTimeStart,
                    currLifeInfo.getLunchTime(), configProvider.lunchTimeEnd)
                ? 2
                : 1;
        progress += currLifeInfo.getMidRestTime() == null
            ? 0
            : VerifyUtils.isBetweenTime(
                    configProvider.midRestTimeStart,
                    currLifeInfo.getMidRestTime(),
                    configProvider.midRestTimeEnd)
                ? 2
                : 1;
        progress += currLifeInfo.getDinnerTime() == null
            ? 0
            : VerifyUtils.isBetweenTime(configProvider.dinnerTimeStart,
                    currLifeInfo.getDinnerTime(), configProvider.dinnerTimeEnd)
                ? 2
                : 1;
        progress += currLifeInfo.getRestTime() == null
            ? 0
            : VerifyUtils.isBetweenTime(configProvider.restTimeStart,
                    currLifeInfo.getRestTime(), configProvider.restTimeEnd)
                ? 2
                : 1;
        todayProgress = progress;
        // 构造点
        if (lastDate != null && lastNightSleepTime != null) {
          sleepTimeFlSpots.add(new FlSpot(
              ConvertUtils.localDaysSinceEpoch(
                      DateTime.fromMillisecondsSinceEpoch(lastDate))
                  .floorToDouble(),
              ConvertUtils.fixedDouble(
                  ConvertUtils.hourFormMilliseconds(lastNightSleepTime), 2)));
        }
        injectKCalFlSpots.add(new FlSpot(
            ConvertUtils.localDaysSinceEpoch(
                    DateTime.fromMillisecondsSinceEpoch(date))
                .floorToDouble(),
            ConvertUtils.fixedDouble(totalCal, 2)));

        progressFlSpots.add(new FlSpot(
            ConvertUtils.localDaysSinceEpoch(
                    DateTime.fromMillisecondsSinceEpoch(date))
                .floorToDouble(),
            ConvertUtils.fixedDouble(progress / 12, 2)));

        if (currLifeInfo.getGetUpTime() != null) {
          getUpTimeFlSpots.add(new FlSpot(
              ConvertUtils.localDaysSinceEpoch(
                      DateTime.fromMillisecondsSinceEpoch(date))
                  .floorToDouble(),
              24 -
                  ConvertUtils.hourFormMillisecondsSinceEpoch(
                      currLifeInfo.getGetUpTime())));
        }
        if (currLifeInfo.getMidRestTime() != null) {
          midRestTimeFlSpots.add(new FlSpot(
              ConvertUtils.localDaysSinceEpoch(
                      DateTime.fromMillisecondsSinceEpoch(date))
                  .floorToDouble(),
              24 -
                  ConvertUtils.hourFormMillisecondsSinceEpoch(
                      currLifeInfo.getMidRestTime())));
        }
        if (currLifeInfo.getRestTime() != null) {
          restTimeFlSpots.add(new FlSpot(
              ConvertUtils.localDaysSinceEpoch(
                      DateTime.fromMillisecondsSinceEpoch(date))
                  .floorToDouble(),
              24 -
                  ConvertUtils.hourFormMillisecondsSinceEpoch(
                      currLifeInfo.getRestTime())));
        }

        if (currLifeInfo.getBreakfastTime() != null) {
          eatBreakfastTimeFlSpots.add(new FlSpot(
              ConvertUtils.localDaysSinceEpoch(
                      DateTime.fromMillisecondsSinceEpoch(date))
                  .floorToDouble(),
              24 -
                  ConvertUtils.hourFormMillisecondsSinceEpoch(
                      currLifeInfo.getBreakfastTime())));
        }
        if (currLifeInfo.getLunchTime() != null) {
          eatLunchTimeFlSpots.add(new FlSpot(
              ConvertUtils.localDaysSinceEpoch(
                      DateTime.fromMillisecondsSinceEpoch(date))
                  .floorToDouble(),
              24 -
                  ConvertUtils.hourFormMillisecondsSinceEpoch(
                      currLifeInfo.getLunchTime())));
        }
        if (currLifeInfo.getDinnerTime() != null) {
          eatDinnerTimeFlSpots.add(new FlSpot(
              ConvertUtils.localDaysSinceEpoch(
                      DateTime.fromMillisecondsSinceEpoch(date))
                  .floorToDouble(),
              24 -
                  ConvertUtils.hourFormMillisecondsSinceEpoch(
                      currLifeInfo.getDinnerTime())));
        }

        double totalMoney = 0;
        totalMoney += currLifeInfo.getBreakfastMoney() ?? 0;
        totalMoney += currLifeInfo.getLunchMoney() ?? 0;
        totalMoney += currLifeInfo.getDinnerMoney() ?? 0;
        moneyFlSpots.add(FlSpot(
            ConvertUtils.localDaysSinceEpoch(
                    DateTime.fromMillisecondsSinceEpoch(date))
                .floorToDouble(),
            ConvertUtils.fixedDouble(totalMoney, 2)));
        todayMoney = totalMoney;
      }
    }
    notifyListeners();
  }

  int sevenDayExerciseTimes = 0;
  double sevenDayExerciseTotalKCal = 0;
  int scheduledExerciseCount = 0;

  List<MapEntry<ScheduledExercise, SportInfo>> scheduledExerciseSportInfoList =
      [];

  List<FlSpot> exerciseInfoFlSpots = [];
  int exerciseInfoChartSize = 7;

  Future<void> loadExerciseInfoData() async {
    int date90daysAgo = ConvertUtils.dateOfDateTime(DateTime.now())
        .subtract(Duration(days: 90))
        .millisecondsSinceEpoch;
    int date7daysAgo = ConvertUtils.dateOfDateTime(DateTime.now())
        .subtract(Duration(days: 7))
        .millisecondsSinceEpoch;
    List<ExerciseInfo> exerciseInfoList = await ExerciseInfoMapper()
        .selectWhere("exerciseTime >= $date90daysAgo");
    List<ExerciseInfo> sevenDayExerciseInfoList =
        await ExerciseInfoMapper().selectWhere("exerciseTime >= $date7daysAgo");
    List<ScheduledExercise> schedules =
        await ScheduledExerciseMapper().selectAll();
    List<SportInfo> sports = await SportInfoMapper().selectAll();
    scheduledExerciseSportInfoList = schedules.map((i) {
      return MapEntry(
          i, sports.firstWhere((test) => test.getId() == i.getSportId()));
    }).toList();
    // 卡
    scheduledExerciseCount = schedules.length;
    sevenDayExerciseTimes = sevenDayExerciseInfoList.length;
    sevenDayExerciseTotalKCal = 0;
    sevenDayExerciseInfoList.forEach((i) {
      sevenDayExerciseTotalKCal += i.getExerciseQuantity() *
          sports
              .firstWhere((test) => test.getId() == i.getSportId())
              .getHkCalorie();
    });
    // 表
    exerciseInfoFlSpots = [];
    Map<int, double> temp = {};
    exerciseInfoList.forEach((i) {
      int currDay = ConvertUtils.localDaysSinceEpoch(
              DateTime.fromMillisecondsSinceEpoch(i.getExerciseTime()))
          .floor();
      if (temp[currDay] == null) {
        temp[currDay] = i.getExerciseQuantity() *
            sports
                .firstWhere((test) => test.getId() == i.getSportId())
                .getHkCalorie();
      } else {
        temp[currDay] += i.getExerciseQuantity() *
            sports
                .firstWhere((test) => test.getId() == i.getSportId())
                .getHkCalorie();
      }
    });
    temp.forEach((k, v) {
      exerciseInfoFlSpots
          .add(FlSpot(k.toDouble(), ConvertUtils.fixedDouble(v, 2)));
    });
    notifyListeners();
  }

  int lateTimes = 0;
  int absentTimes = 0;
  int unSolveTroubles = 0;
  int unDoneHomeWorks = 0;
  List<StudyInfo> unSolveStudyInfoList = [];

  List<FlSpot> dailyStudyCountFlSpots = [];
  int dailyStudyCountChartSize = 7;

  Future<void> loadStudyInfoData() async {
    int date90daysAgo = ConvertUtils.dateOfDateTime(DateTime.now())
        .subtract(Duration(days: 90))
        .millisecondsSinceEpoch;
    List<StudyInfo> studyInfoList =
        await StudyInfoMapper().selectWhere("date >= $date90daysAgo");
    List<StudyInfo> lateList =
        await StudyInfoMapper().selectWhere("isLate = 1");
    List<StudyInfo> absentList =
        await StudyInfoMapper().selectWhere("isAbsent = 1");
    List<StudyInfo> unSolveTroublesAndUnDoneHomeList = await StudyInfoMapper()
        .selectWhere("isTroublesSolved = 0 or isHomeWorkDone == 0");
    lateTimes = 0;
    absentTimes = 0;
    unSolveTroubles = 0;
    unDoneHomeWorks = 0;
    lateTimes = lateList.length;
    absentTimes = absentList.length;
    unSolveStudyInfoList = [];
    unSolveTroubles = 0;
    unDoneHomeWorks = 0;
    unSolveTroublesAndUnDoneHomeList.forEach((i) {
      unSolveStudyInfoList.add(i);
      if (i.getIsHomeWorkDone() == 0) {
        unDoneHomeWorks++;
      }
      if (i.getIsTroublesSolved() == 0) {
        unSolveTroubles++;
      }
    });

    dailyStudyCountFlSpots = [];

    Map<int, int> temp = {};
    studyInfoList.forEach((i) {
      int currDay = ConvertUtils.localDaysSinceEpoch(
              DateTime.fromMillisecondsSinceEpoch(i.getDate()))
          .floor();
      if (temp[currDay] == null) {
        temp[currDay] = 1;
      } else {
        temp[currDay] += 1;
      }
    });
    temp.forEach((key, value) {
      dailyStudyCountFlSpots.add(new FlSpot(key.toDouble(), value.toDouble()));
    });
    notifyListeners();
  }

  int todayEvaluate = 0;

  Future<void> evaluateToday() async {
    // 0 - 15
    todayEvaluate = 0;
    todayEvaluate += todayProgress;
    int todayZeroTime =
        ConvertUtils.dateOfDateTime(DateTime.now()).millisecondsSinceEpoch;
    List<BasicInfo> l1 =
        await BasicInfoMapper().selectWhere("date >= $todayZeroTime");
    if (l1.isNotEmpty) {
      todayEvaluate++;
    }
    List<ExerciseInfo> l2 =
    await ExerciseInfoMapper().selectWhere("exerciseTime >= $todayZeroTime");
    if (l2.isNotEmpty) {
      todayEvaluate++;
    }
    List<StudyInfo> l3 =
    await StudyInfoMapper().selectWhere("date >= $todayZeroTime");
    if (l3.isNotEmpty) {
      todayEvaluate++;
    }
    notifyListeners();
  }
}
