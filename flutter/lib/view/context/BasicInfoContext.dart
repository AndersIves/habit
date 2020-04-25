import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/view/context/widget/BaseCard.dart';
import 'package:habit/view/context/widget/DateValueMultiLineChart.dart';
import 'package:habit/view/context/widget/DateValueSingleLineChart.dart';
import 'package:provider/provider.dart';

class BasicInfoContext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BasicInfoContextService>(
            create: (_) => BasicInfoContextService(context)),
      ],
      child: _BasicInfoContextView(),
    );
  }
}

// service
class BasicInfoContextService extends BaseService {
  BasicInfoContextService(BuildContext context) : super(context);

  void changeSizeOfWeightChartCard(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    switch (dataProvider.weightChartSize) {
      case 7:
        dataProvider.weightChartSize = 30;
        break;
      case 30:
        dataProvider.weightChartSize = 90;
        break;
      case 90:
        dataProvider.weightChartSize = 7;
        break;
    }
    dataProvider.notifyListeners();
  }

  void changeSizeOfBwhChartCard(BuildContext context) {
    DataProvider dataProvider =
    Provider.of<DataProvider>(context, listen: false);
    switch (dataProvider.bwhChartSize) {
      case 7:
        dataProvider.bwhChartSize = 30;
        break;
      case 30:
        dataProvider.bwhChartSize = 90;
        break;
      case 90:
        dataProvider.bwhChartSize = 7;
        break;
    }
    dataProvider.notifyListeners();
  }
}

// view
class _BasicInfoContextView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        baseInfoCard(context),
        weightChartCard(context),
        bwhChartCard(context),
      ],
    );
  }

  Widget baseInfoCard(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        userProvider.userName ?? "Habit",
        maxLines: 1,
        style: Theme.of(context).textTheme.title.copyWith(fontSize: 35),
      ),
      subtitle: Text(I18N.of("基本信息")),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          userProvider.photo == null
              ? Icon(
                  Icons.account_box,
                  size: 170,
                  color: Theme.of(context).unselectedWidgetColor,
                )
              : Padding(
                  padding: EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      userProvider.photo,
                      width: 130,
                      height: 130,
                    ),
                  ),
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${I18N.of("身高")}: ${ConvertUtils.packString(dataProvider.height)} cm",
                style: TextStyle(height: 1.5),
              ),
              Text(
                "${I18N.of("体重")}: ${ConvertUtils.packString(dataProvider.weight)} kg",
                style: TextStyle(height: 1.5),
              ),
              Text(
                "${I18N.of("BMI")}:  ${ConvertUtils.packString(dataProvider.bmi)} kg/m²",
                style: TextStyle(height: 1.5),
              ),
              Text(
                "${I18N.of("胸围")}: ${ConvertUtils.packString(dataProvider.breastLine)} cm",
                style: TextStyle(height: 1.5),
              ),
              Text(
                "${I18N.of("腰围")}: ${ConvertUtils.packString(dataProvider.hipLine)} cm",
                style: TextStyle(height: 1.5),
              ),
              Text(
                "${I18N.of("臀围")}: ${ConvertUtils.packString(dataProvider.waistLine)} cm",
                style: TextStyle(height: 1.5),
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }

  Widget weightChartCard(BuildContext context) {
    BasicInfoContextService service =
        Provider.of<BasicInfoContextService>(context, listen: false);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        "${I18N.of("体重信息")} (kg)",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Container(
        height: 25,
        child: FlatButton(
          child: Text("< ${dataProvider.weightChartSize} >"),
          onPressed: () => service.changeSizeOfWeightChartCard(context),
        ),
      ),
      child: DateValueSingleLineChart(
        size: dataProvider.weightChartSize,
        sports: dataProvider.weightFlSpots,
      ),
    );
  }

  Widget bwhChartCard(BuildContext context) {
    BasicInfoContextService service =
        Provider.of<BasicInfoContextService>(context, listen: false);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: true);
    return BaseCard(
      title: Text(
        "${I18N.of("三围信息")} (cm)",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Container(
        height: 25,
        child: FlatButton(
          child: Text("< ${dataProvider.bwhChartSize} >"),
          onPressed: () => service.changeSizeOfBwhChartCard(context),
        ),
      ),
      child: DateValueMultiLineChart(
        size: dataProvider.bwhChartSize,
        lineNameSportsMap: {
          I18N.of("胸围") : dataProvider.brestLineFlSpots,
          I18N.of("腰围") : dataProvider.waistLineFlSpots,
          I18N.of("臀围") : dataProvider.hipLineFlSpots
        },
      ),
    );
  }
}
