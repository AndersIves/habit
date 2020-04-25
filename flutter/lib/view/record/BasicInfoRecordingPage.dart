import 'dart:math';

import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/database/entity/BasicInfo.dart';
import 'package:habit/database/mapper/BasicInfoMapper.dart';
import 'package:habit/network/Repository.dart';
import 'package:habit/view/record/AdjustButtonRow.dart';
import 'package:provider/provider.dart';

class BasicInfoRecordingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BasicInfoRecordingPageService>(
            create: (_) => BasicInfoRecordingPageService(context)),
        ChangeNotifierProvider<BasicInfoRecordingPageModel>(
            create: (_) => BasicInfoRecordingPageModel(context)),
      ],
      child: _BasicInfoRecordingPageView(),
    );
  }
}

// model
class BasicInfoRecordingPageModel extends BaseModel {
  BasicInfoRecordingPageModel(BuildContext context) : super(context);
  double height;
  double weight;
  double breastLine;
  double waistLine;
  double hipLine;

  @override
  void init(BuildContext context) {
    // TODO: implement init
    super.init(context);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    height = dataProvider.height ?? 165;
    weight = dataProvider.weight ?? 55;
    breastLine = dataProvider.breastLine ?? 86;
    waistLine = dataProvider.waistLine ?? 66;
    hipLine = dataProvider.hipLine ?? 90;
  }
}

// service
class BasicInfoRecordingPageService extends BaseService {
  BasicInfoRecordingPageService(BuildContext context) : super(context);

  Future<void> record(BuildContext context) async {
    BasicInfoRecordingPageModel model =
        Provider.of<BasicInfoRecordingPageModel>(context, listen: false);
    // 今日是否记录过
    DateTime now = DateTime.now();
    List<BasicInfo> list = await BasicInfoMapper().selectWhere(
        "date >= ${ConvertUtils.dateOfDateTime(now).millisecondsSinceEpoch}");
    BasicInfo basicInfo = new BasicInfo();
    basicInfo.setHeight(model.height);
    basicInfo.setWeight(model.weight);
    basicInfo.setBreastLine(model.breastLine);
    basicInfo.setWaistLine(model.waistLine);
    basicInfo.setHipLine(model.hipLine);
    basicInfo.setDate(now.millisecondsSinceEpoch);
    if (list.isNotEmpty) {
      await PopMenus.sliderConfirm(
        context: context,
        content: Text(I18N.of("滑动来覆盖今日数据")),
        function: () async {
          basicInfo.setId(list.last.getId());
          await BasicInfoMapper().updateByFirstKeySelective(basicInfo);
          await PopMenus.attention(
              context: context, content: Text(I18N.of("记录成功")));
          await Provider.of<DataProvider>(context, listen: false).loadBasicInfoData();
          Navigator.of(context).pop();
        },
      );
    } else {
      await BasicInfoMapper().insert(basicInfo);
      await PopMenus.attention(
          context: context, content: Text(I18N.of("记录成功")));
      await Provider.of<DataProvider>(context, listen: false).loadBasicInfoData();
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      if (userProvider.token != null) {
        // 增加金币
        int increasedCoin = await Repository.getInstance()
            .increaseCoin(context, userProvider.uid, userProvider.token);
        if (increasedCoin != null) {
          await PopMenus.coinAdd(context: context, addedCoins: increasedCoin);
          userProvider.coins += increasedCoin;
          userProvider.refresh();
        }
      }
      Navigator.of(context).pop();
    }
  }
}

// view
class _BasicInfoRecordingPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BasicInfoRecordingPageService service =
        Provider.of<BasicInfoRecordingPageService>(context, listen: false);
    BasicInfoRecordingPageModel model =
        Provider.of<BasicInfoRecordingPageModel>(context, listen: true);
    BasicInfoRecordingPageModel modelListenFalse =
        Provider.of<BasicInfoRecordingPageModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("基本信息记录")),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          children: <Widget>[
//            FlatButton(
//              child: Text("测试数据"),
//              onPressed: () async {
//                await _test(context);
//              },
//            ),
            SlideAdjuster(
              titleString: "${I18N.of("身高")} (cm)",
              startValue: modelListenFalse.height,
              onValueChange: (v) => modelListenFalse.height = v,
            ),
            SlideAdjuster(
              titleString: "${I18N.of("体重")} (kg)",
              startValue: modelListenFalse.weight,
              onValueChange: (v) => modelListenFalse.weight = v,
            ),
            SlideAdjuster(
              titleString: "${I18N.of("胸围")} (cm)",
              startValue: modelListenFalse.breastLine,
              onValueChange: (v) => modelListenFalse.breastLine = v,
            ),
            SlideAdjuster(
              titleString: "${I18N.of("腰围")} (cm)",
              startValue: modelListenFalse.waistLine,
              onValueChange: (v) => modelListenFalse.waistLine = v,
            ),
            SlideAdjuster(
              titleString: "${I18N.of("臀围")} (cm)",
              startValue: modelListenFalse.hipLine,
              onValueChange: (v) => modelListenFalse.hipLine = v,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: RaisedButton(
                child: Text(I18N.of("记录")),
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).cardColor,
                onPressed: () => service.record(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
