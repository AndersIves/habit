import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/ConfigProvider.dart';
import 'package:habit/common/provider/NotificationProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:provider/provider.dart';

class NotificationSetPage extends StatefulWidget {
  @override
  _NotificationSetPageState createState() => _NotificationSetPageState();
}

class _NotificationSetPageState extends State<NotificationSetPage> {
  @override
  Widget build(BuildContext context) {
    ConfigProvider configProvider =
        Provider.of<ConfigProvider>(context, listen: true);
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context, listen: true);
    NotificationProvider notificationProviderUnListen =
        Provider.of<NotificationProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("通知开关")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text(I18N.of("起床打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.getUpTimeStart)}"),
              trailing: Switch(
                value: notificationProvider.getUpNotification,
                onChanged: (bool value) async {
                  notificationProviderUnListen.getUpNotification = value;
                  await notificationProviderUnListen.refresh();
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.free_breakfast),
              title: Text(I18N.of("早饭打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.breakfastTimeStart)}"),
              trailing: Switch(
                value: notificationProvider.breakfastNotification,
                onChanged: (bool value) async {
                  notificationProviderUnListen.breakfastNotification = value;
                  await notificationProviderUnListen.refresh();
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.local_dining),
              title: Text(I18N.of("午饭打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.lunchTimeStart)}"),
              trailing: Switch(
                value: notificationProvider.lunchNotification,
                onChanged: (bool value) async {
                  notificationProviderUnListen.lunchNotification = value;
                  await notificationProviderUnListen.refresh();
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.local_hotel),
              title: Text(I18N.of("午休打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.midRestTimeStart)}"),
              trailing: Switch(
                value: notificationProvider.midRestNotification,
                onChanged: (bool value) async {
                  notificationProviderUnListen.midRestNotification = value;
                  await notificationProviderUnListen.refresh();
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text(I18N.of("晚饭打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.dinnerTimeStart)}"),
              trailing: Switch(
                value: notificationProvider.dinnerNotification,
                onChanged: (bool value) async {
                  notificationProviderUnListen.dinnerNotification = value;
                  await notificationProviderUnListen.refresh();
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.brightness_4),
              title: Text(I18N.of("晚安打卡")),
              subtitle: Text(
                  "${ConvertUtils.timeFormMillisecondsSinceEpoch(configProvider.restTimeStart)}"),
              trailing: Switch(
                value: notificationProvider.restNotification,
                onChanged: (bool value) async {
                  notificationProviderUnListen.restNotification = value;
                  await notificationProviderUnListen.refresh();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
