import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/LocalData.dart';
import 'package:habit/common/provider/ConfigProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool getUpNotification;
  bool breakfastNotification;
  bool lunchNotification;
  bool midRestNotification;
  bool dinnerNotification;
  bool restNotification;

  Future<void> init() async {
    await initFlutterLocalNotificationsPlugin();
    load();
    store();
    await startScheduledTasks();
  }

  Future<void> initFlutterLocalNotificationsPlugin() async {
    if (flutterLocalNotificationsPlugin == null) {
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      AndroidInitializationSettings initializationSettingsAndroid =
          new AndroidInitializationSettings("logo");
      IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings();
      InitializationSettings initializationSettings = InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings);
      debugPrint("init NotificationsUtils");
    }
  }

  Future<void> cancelScheduledTasks() async {
    await cancel(1);
    await cancel(2);
    await cancel(3);
    await cancel(4);
    await cancel(5);
    await cancel(6);
    debugPrint("cancelScheduledTasks");
  }


  Future<List<PendingNotificationRequest>> getNotifications() async {
    List pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  Future<void> startScheduledTasks() async {
    await cancelScheduledTasks();
    ConfigProvider configProvider = new ConfigProvider();
    configProvider.load();
    if (getUpNotification) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(configProvider.getUpTimeStart);
      await scheduledNotice(
        1,
        "Habit ${I18N.of("打卡提醒")}",
        I18N.of("起床打卡开始了"),
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      );
    }
    if (breakfastNotification) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          configProvider.breakfastTimeStart);
      await scheduledNotice(
        2,
        "Habit ${I18N.of("打卡提醒")}",
        I18N.of("早饭打卡开始了"),
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      );
    }
    if (lunchNotification) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(configProvider.lunchTimeStart);
      await scheduledNotice(
        3,
        "Habit ${I18N.of("打卡提醒")}",
        I18N.of("午饭打卡开始了"),
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      );
    }
    if (midRestNotification) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(configProvider.midRestTimeStart);
      await scheduledNotice(
        4,
        "Habit ${I18N.of("打卡提醒")}",
        I18N.of("午休打卡开始了"),
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      );
    }
    if (dinnerNotification) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(configProvider.dinnerTimeStart);
      await scheduledNotice(
        5,
        "Habit ${I18N.of("打卡提醒")}",
        I18N.of("起床打卡开始了"),
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      );
    }
    if (restNotification) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(configProvider.restTimeStart);
      await scheduledNotice(
        6,
        "Habit ${I18N.of("打卡提醒")}",
        I18N.of("睡觉打卡开始了"),
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      );
    }
    debugPrint("startScheduledTasks");
  }

  Future<void> scheduledNotice(int id, String title, String body, int hour,
      int minute, int second) async {
    Time time = new Time(hour, minute, second);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(id.toString(), title, body);
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        new IOSNotificationDetails();

    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, body, time, platformChannelSpecifics);
    debugPrint("scheduledNotice $hour $minute $second");
  }


  Future<void> notice(int id, String title, String body) async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(id.toString(), title, body,
        importance: Importance.Max, priority: Priority.High, ticker: title);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics);
  }

  Future<void> cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }


  void load() {
    SharedPreferences sp = LocalData.getInstance();
    getUpNotification = sp.getBool("getUpNotification") ?? true;
    breakfastNotification = sp.getBool("breakfastNotification") ?? true;
    lunchNotification = sp.getBool("lunchNotification") ?? true;
    midRestNotification = sp.getBool("midRestNotification") ?? true;
    dinnerNotification = sp.getBool("dinnerNotification") ?? true;
    restNotification = sp.getBool("restNotification") ?? true;
  }

  void store() {
    SharedPreferences sp = LocalData.getInstance();
    sp.setBool("getUpNotification", getUpNotification);
    sp.setBool("breakfastNotification", breakfastNotification);
    sp.setBool("lunchNotification", lunchNotification);
    sp.setBool("midRestNotification", midRestNotification);
    sp.setBool("dinnerNotification", dinnerNotification);
    sp.setBool("restNotification", restNotification);
  }

  Future<void> refresh() async {
    store();
    await startScheduledTasks();
    notifyListeners();
  }
}
