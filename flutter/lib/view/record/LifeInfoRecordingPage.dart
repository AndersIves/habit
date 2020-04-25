import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/ConfigProvider.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/common/utils/VerificationUtils.dart';
import 'package:habit/database/entity/FoodInfo.dart';
import 'package:habit/database/entity/LifeInfo.dart';
import 'package:habit/database/mapper/FoodInfoMapper.dart';
import 'package:habit/database/mapper/LifeInfoMapper.dart';
import 'package:habit/network/Repository.dart';
import 'package:habit/view/record/sub/FoodRecordPage.dart';
import 'package:provider/provider.dart';

class LifeInfoRecordingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LifeInfoRecordingPageService>(
            create: (_) => LifeInfoRecordingPageService(context)),
        ChangeNotifierProvider<LifeInfoRecordingPageModel>(
            create: (_) => LifeInfoRecordingPageModel(context)),
      ],
      child: _LifeInfoRecordingPageView(),
    );
  }
}

// model
class LifeInfoRecordingPageModel extends BaseModel {
  LifeInfoRecordingPageModel(BuildContext context) : super(context);

  int currId;
  bool isSignGetUp;
  bool isSignBreakfast;
  bool isSignMidRest;
  bool isSignLunch;
  bool isSignDinner;
  bool isSignRest;

  @override
  void init(BuildContext context) {
    // TODO: implement init
    super.init(context);
    currId = null;
    isSignGetUp = true;
    isSignBreakfast = true;
    isSignMidRest = true;
    isSignLunch = true;
    isSignDinner = true;
    isSignRest = true;
  }

  @override
  Future<void> asyncInit(BuildContext context) async {
    DateTime now = DateTime.now();
    List<LifeInfo> list = await LifeInfoMapper().selectWhere(
        "date >= ${ConvertUtils.dateOfDateTime(now).millisecondsSinceEpoch}");
    if (list.isNotEmpty) {
      LifeInfo localLifeInfo = list[0];
      currId = list[0].getId();
      isSignGetUp = localLifeInfo.getGetUpTime() != null;
      isSignBreakfast = localLifeInfo.getBreakfastTime() != null;
      isSignMidRest = localLifeInfo.getMidRestTime() != null;
      isSignLunch = localLifeInfo.getLunchTime() != null;
      isSignDinner = localLifeInfo.getDinnerTime() != null;
      isSignRest = localLifeInfo.getRestTime() != null;
    } else {
      await LifeInfoMapper()
          .insert(new LifeInfo().setDate(now.millisecondsSinceEpoch));
      list = await LifeInfoMapper().selectWhere(
          "date >= ${ConvertUtils.dateOfDateTime(now).millisecondsSinceEpoch}");
      currId = list[0].getId();
      isSignGetUp = false;
      isSignBreakfast = false;
      isSignMidRest = false;
      isSignLunch = false;
      isSignDinner = false;
      isSignRest = false;
    }
    refresh();
  }
}

// service
class LifeInfoRecordingPageService extends BaseService {
  LifeInfoRecordingPageService(BuildContext context) : super(context);

  Future<void> signGetUp(BuildContext context) async {
    LifeInfoRecordingPageModel model =
        Provider.of<LifeInfoRecordingPageModel>(context, listen: false);
    ConfigProvider configProvider =
        Provider.of<ConfigProvider>(context, listen: false);
    // 记录
    await PopMenus.sliderConfirm(
      context: context,
      content: Text(I18N.of("滑动来打卡")),
      function: () async {
        LifeInfo lifeInfo = new LifeInfo();
        lifeInfo.setId(model.currId);
        lifeInfo.setGetUpTime(DateTime.now().millisecondsSinceEpoch);
        model.isSignGetUp =
            await LifeInfoMapper().updateByFirstKeySelective(lifeInfo);

        // 时间验证
        if (!VerifyUtils.nowIsBetweenTime(
            configProvider.getUpTimeStart, configProvider.getUpTimeEnd)) {
          await PopMenus.attention(
              context: context, content: Text(I18N.of("非打卡时间打卡成功")));
        } else {
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
        model.refresh();
        await Provider.of<DataProvider>(context, listen: false)
            .loadLifeInfoData();
      },
    );
  }

  Future<void> signBreakfast(BuildContext context) async {
    LifeInfoRecordingPageModel model =
        Provider.of<LifeInfoRecordingPageModel>(context, listen: false);
    ConfigProvider configProvider =
        Provider.of<ConfigProvider>(context, listen: false);
    List info = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => FoodRecordPage()));
    if (info != null) {
      LifeInfo lifeInfo = new LifeInfo();
      lifeInfo.setId(model.currId);
      lifeInfo.setBreakfastId(info[0]);
      lifeInfo.setBreakfastQuantity(info[1]);
      lifeInfo.setBreakfastMoney(info[3]);
      lifeInfo.setBreakfastTime(DateTime.now().millisecondsSinceEpoch);
      model.isSignBreakfast =
          await LifeInfoMapper().updateByFirstKeySelective(lifeInfo);
      // 增加食用次数
      FoodInfo foodInfo = new FoodInfo();
      foodInfo.setId(info[0]);
      foodInfo.setEatTimes(info[2] + 1);
      await FoodInfoMapper().updateByFirstKeySelective(foodInfo);
      // 时间验证
      if (!VerifyUtils.nowIsBetweenTime(
          configProvider.breakfastTimeStart, configProvider.breakfastTimeEnd)) {
        await PopMenus.attention(
            context: context, content: Text(I18N.of("非打卡时间打卡成功")));
      } else {
        // 增加金币
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        if (userProvider.token != null) {
          int increasedCoin = await Repository.getInstance()
              .increaseCoin(context, userProvider.uid, userProvider.token);
          if (increasedCoin != null) {
            await PopMenus.coinAdd(context: context, addedCoins: increasedCoin);
            userProvider.coins += increasedCoin;
            userProvider.refresh();
          }
        }
      }
      model.refresh();
      await Provider.of<DataProvider>(context, listen: false)
          .loadLifeInfoData();
    }
  }

  Future<void> signLunch(BuildContext context) async {
    LifeInfoRecordingPageModel model =
        Provider.of<LifeInfoRecordingPageModel>(context, listen: false);
    ConfigProvider configProvider =
        Provider.of<ConfigProvider>(context, listen: false);
    List info = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => FoodRecordPage()));
    if (info != null) {
      LifeInfo lifeInfo = new LifeInfo();
      lifeInfo.setId(model.currId);
      lifeInfo.setLunchId(info[0]);
      lifeInfo.setLunchQuantity(info[1]);
      lifeInfo.setLunchMoney(info[3]);
      lifeInfo.setLunchTime(DateTime.now().millisecondsSinceEpoch);
      model.isSignLunch =
          await LifeInfoMapper().updateByFirstKeySelective(lifeInfo);
      // 增加食用次数
      FoodInfo foodInfo = new FoodInfo();
      foodInfo.setId(info[0]);
      foodInfo.setEatTimes(info[2] + 1);
      await FoodInfoMapper().updateByFirstKeySelective(foodInfo);
      // 时间验证
      if (!VerifyUtils.nowIsBetweenTime(
          configProvider.lunchTimeStart, configProvider.lunchTimeEnd)) {
        await PopMenus.attention(
            context: context, content: Text(I18N.of("非打卡时间打卡成功")));
      } else {
        // 增加金币
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        if (userProvider.token != null) {
          int increasedCoin = await Repository.getInstance()
              .increaseCoin(context, userProvider.uid, userProvider.token);
          if (increasedCoin != null) {
            await PopMenus.coinAdd(context: context, addedCoins: increasedCoin);
            userProvider.coins += increasedCoin;
            userProvider.refresh();
          }
        }
      }
      model.refresh();
      await Provider.of<DataProvider>(context, listen: false)
          .loadLifeInfoData();
    }
  }

  Future<void> signDinner(BuildContext context) async {
    LifeInfoRecordingPageModel model =
        Provider.of<LifeInfoRecordingPageModel>(context, listen: false);
    ConfigProvider configProvider =
        Provider.of<ConfigProvider>(context, listen: false);
    List info = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => FoodRecordPage()));
    if (info != null) {
      LifeInfo lifeInfo = new LifeInfo();
      lifeInfo.setId(model.currId);
      lifeInfo.setDinnerId(info[0]);
      lifeInfo.setDinnerQuantity(info[1]);
      lifeInfo.setDinnerMoney(info[3]);
      lifeInfo.setDinnerTime(DateTime.now().millisecondsSinceEpoch);
      model.isSignDinner =
          await LifeInfoMapper().updateByFirstKeySelective(lifeInfo);
      // 增加食用次数
      FoodInfo foodInfo = new FoodInfo();
      foodInfo.setId(info[0]);
      foodInfo.setEatTimes(info[2] + 1);
      await FoodInfoMapper().updateByFirstKeySelective(foodInfo);
      // 时间验证
      if (!VerifyUtils.nowIsBetweenTime(
          configProvider.dinnerTimeStart, configProvider.dinnerTimeEnd)) {
        await PopMenus.attention(
            context: context, content: Text(I18N.of("非打卡时间打卡成功")));
      } else {
        // 增加金币
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        if (userProvider.token != null) {
          int increasedCoin = await Repository.getInstance()
              .increaseCoin(context, userProvider.uid, userProvider.token);
          if (increasedCoin != null) {
            await PopMenus.coinAdd(context: context, addedCoins: increasedCoin);
            userProvider.coins += increasedCoin;
            userProvider.refresh();
          }
        }
      }
      model.refresh();
      await Provider.of<DataProvider>(context, listen: false)
          .loadLifeInfoData();
    }
  }

  Future<void> signRest(BuildContext context) async {
    LifeInfoRecordingPageModel model =
        Provider.of<LifeInfoRecordingPageModel>(context, listen: false);
    ConfigProvider configProvider =
        Provider.of<ConfigProvider>(context, listen: false);
    // 记录
    await PopMenus.sliderConfirm(
      context: context,
      content: Text(I18N.of("滑动来打卡")),
      function: () async {
        LifeInfo lifeInfo = new LifeInfo();
        lifeInfo.setId(model.currId);
        lifeInfo.setRestTime(DateTime.now().millisecondsSinceEpoch);
        model.isSignRest =
            await LifeInfoMapper().updateByFirstKeySelective(lifeInfo);
        // 时间验证
        if (!VerifyUtils.nowIsBetweenTime(
            configProvider.restTimeStart, configProvider.restTimeEnd)) {
          await PopMenus.attention(
              context: context, content: Text(I18N.of("非打卡时间打卡成功")));
        } else {
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
        model.refresh();
        await Provider.of<DataProvider>(context, listen: false)
            .loadLifeInfoData();
      },
    );
  }

  Future<void> signMidRest(BuildContext context) async {
    LifeInfoRecordingPageModel model =
        Provider.of<LifeInfoRecordingPageModel>(context, listen: false);
    ConfigProvider configProvider =
        Provider.of<ConfigProvider>(context, listen: false);
    // 记录
    await PopMenus.sliderConfirm(
      context: context,
      content: Text(I18N.of("滑动来打卡")),
      function: () async {
        LifeInfo lifeInfo = new LifeInfo();
        lifeInfo.setId(model.currId);
        lifeInfo.setMidRestTime(DateTime.now().millisecondsSinceEpoch);
        model.isSignMidRest =
            await LifeInfoMapper().updateByFirstKeySelective(lifeInfo);
        // 时间验证
        if (!VerifyUtils.nowIsBetweenTime(
            configProvider.midRestTimeStart, configProvider.midRestTimeEnd)) {
          await PopMenus.attention(
              context: context, content: Text(I18N.of("非打卡时间打卡成功")));
        } else {
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
        model.refresh();
        await Provider.of<DataProvider>(context, listen: false)
            .loadLifeInfoData();
      },
    );
  }
}

// view
class _LifeInfoRecordingPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LifeInfoRecordingPageService service =
        Provider.of<LifeInfoRecordingPageService>(context, listen: false);
    LifeInfoRecordingPageModel model =
        Provider.of<LifeInfoRecordingPageModel>(context, listen: true);
    ConfigProvider configProvider =
        Provider.of<ConfigProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("日常生活记录")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text(I18N.of("起床打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.getUpTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.getUpTimeEnd)}"),
              trailing: Icon(
                model.isSignGetUp ? Icons.check_circle : Icons.chevron_right,
                color: model.isSignGetUp ? Theme.of(context).accentColor : null,
              ),
              onTap:
                  model.isSignGetUp ? null : () => service.signGetUp(context),
            ),
            ListTile(
              leading: Icon(Icons.free_breakfast),
              title: Text(I18N.of("早饭打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.breakfastTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.breakfastTimeEnd)}"),
              trailing: Icon(
                model.isSignBreakfast
                    ? Icons.check_circle
                    : Icons.chevron_right,
                color: model.isSignBreakfast
                    ? Theme.of(context).accentColor
                    : null,
              ),
              onTap: model.isSignBreakfast
                  ? null
                  : () => service.signBreakfast(context),
            ),
            ListTile(
              leading: Icon(Icons.local_dining),
              title: Text(I18N.of("午饭打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.lunchTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.lunchTimeEnd)}"),
              trailing: Icon(
                model.isSignLunch ? Icons.check_circle : Icons.chevron_right,
                color: model.isSignLunch ? Theme.of(context).accentColor : null,
              ),
              onTap:
                  model.isSignLunch ? null : () => service.signLunch(context),
            ),
            ListTile(
              leading: Icon(Icons.local_hotel),
              title: Text(I18N.of("午休打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.midRestTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.midRestTimeEnd)}"),
              trailing: Icon(
                model.isSignMidRest ? Icons.check_circle : Icons.chevron_right,
                color:
                    model.isSignMidRest ? Theme.of(context).accentColor : null,
              ),
              onTap: model.isSignMidRest
                  ? null
                  : () => service.signMidRest(context),
            ),
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text(I18N.of("晚饭打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.dinnerTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.dinnerTimeEnd)}"),
              trailing: Icon(
                model.isSignDinner ? Icons.check_circle : Icons.chevron_right,
                color:
                    model.isSignDinner ? Theme.of(context).accentColor : null,
              ),
              onTap:
                  model.isSignDinner ? null : () => service.signDinner(context),
            ),
            ListTile(
              leading: Icon(Icons.brightness_4),
              title: Text(I18N.of("晚安打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.restTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.restTimeEnd)}"),
              trailing: Icon(
                model.isSignRest ? Icons.check_circle : Icons.chevron_right,
                color: model.isSignRest ? Theme.of(context).accentColor : null,
              ),
              onTap: model.isSignRest ? null : () => service.signRest(context),
            ),
          ],
        ),
      ),
    );
  }
}
