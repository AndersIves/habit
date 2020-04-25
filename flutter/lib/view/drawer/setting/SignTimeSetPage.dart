import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/ConfigProvider.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/NotificationProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:provider/provider.dart';

class SignTimeSetPage extends StatefulWidget {
  @override
  _SignTimeSetPageState createState() => _SignTimeSetPageState();
}

class _SignTimeSetPageState extends State<SignTimeSetPage> {
  @override
  Widget build(BuildContext context) {
    ConfigProvider configProvider =
        Provider.of<ConfigProvider>(context, listen: true);
    ConfigProvider configProviderUnListen =
        Provider.of<ConfigProvider>(context, listen: false);
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("打卡时段")),
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
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                await PopMenus.baseMenu(
                  context: context,
                  title: Text(I18N.of("起床打卡时间")),
                  contentPadding: EdgeInsets.all(16),
                  children: [
                    FlatButton(
                      child: Text(I18N.of("起始时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.getUpTimeStart)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.getUpTimeStart =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                    FlatButton(
                      child: Text(I18N.of("结束时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.getUpTimeEnd)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.getUpTimeEnd =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.free_breakfast),
              title: Text(I18N.of("早饭打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.breakfastTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.breakfastTimeEnd)}"),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                await PopMenus.baseMenu(
                  context: context,
                  title: Text(I18N.of("早饭打卡时间")),
                  contentPadding: EdgeInsets.all(16),
                  children: [
                    FlatButton(
                      child: Text(I18N.of("起始时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.breakfastTimeStart)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.breakfastTimeStart =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                    FlatButton(
                      child: Text(I18N.of("结束时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.breakfastTimeEnd)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.breakfastTimeEnd =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.local_dining),
              title: Text(I18N.of("午饭打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.lunchTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.lunchTimeEnd)}"),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                await PopMenus.baseMenu(
                  context: context,
                  title: Text(I18N.of("午饭打卡时间")),
                  contentPadding: EdgeInsets.all(16),
                  children: [
                    FlatButton(
                      child: Text(I18N.of("起始时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.lunchTimeStart)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.lunchTimeStart =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                    FlatButton(
                      child: Text(I18N.of("结束时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.lunchTimeEnd)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.lunchTimeEnd =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.local_hotel),
              title: Text(I18N.of("午休打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.midRestTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.midRestTimeEnd)}"),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                await PopMenus.baseMenu(
                  context: context,
                  title: Text(I18N.of("午休打卡时间")),
                  contentPadding: EdgeInsets.all(16),
                  children: [
                    FlatButton(
                      child: Text(I18N.of("起始时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.midRestTimeStart)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.midRestTimeStart =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                    FlatButton(
                      child: Text(I18N.of("结束时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.midRestTimeEnd)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.midRestTimeEnd =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text(I18N.of("晚饭打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.dinnerTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.dinnerTimeEnd)}"),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                await PopMenus.baseMenu(
                  context: context,
                  title: Text(I18N.of("起床打卡时间")),
                  contentPadding: EdgeInsets.all(16),
                  children: [
                    FlatButton(
                      child: Text(I18N.of("起始时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.dinnerTimeStart)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.dinnerTimeStart =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                    FlatButton(
                      child: Text(I18N.of("结束时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.dinnerTimeEnd)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.dinnerTimeEnd =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_4),
              title: Text(I18N.of("晚安打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.restTimeStart)} - ${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.restTimeEnd)}"),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                await PopMenus.baseMenu(
                  context: context,
                  title: Text(I18N.of("起床打卡时间")),
                  contentPadding: EdgeInsets.all(16),
                  children: [
                    FlatButton(
                      child: Text(I18N.of("起始时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.restTimeStart)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.restTimeStart =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                    FlatButton(
                      child: Text(I18N.of("结束时间")),
                      onPressed: () async {
                        TimeOfDay res = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  configProvider.restTimeEnd)),
                        );
                        if (res != null) {
                          Navigator.of(context).pop();
                          configProviderUnListen.restTimeEnd =
                              DateTime(1, 1, 1, res.hour, res.minute)
                                  .millisecondsSinceEpoch;
                          configProviderUnListen.store();
                          configProviderUnListen.refresh();
                          await dataProvider.loadLifeInfoData();
                          await dataProvider.evaluateToday();
                          await Provider.of<NotificationProvider>(context, listen: false).refresh();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
