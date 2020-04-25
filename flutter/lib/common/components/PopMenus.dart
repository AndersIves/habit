import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:provider/provider.dart';

import 'SliderConfirm.dart';
import 'UserInfoPopMenuContext.dart';

class PopMenus {
  static Future<void> confirm({
    @required BuildContext context,
    Widget content,
    @required Function function,
  }) async {
    await baseAlertMenu<int>(
      context: context,
      content: content ?? Text(I18N.of("继续该操作吗？")),
      actions: [
        FlatButton(
          child: Text(I18N.of("取消")),
          onPressed: () {
            Navigator.of(context).pop(0);
          },
        ),
        FlatButton(
          child: Text(I18N.of("确定")),
          onPressed: () {
            Navigator.of(context).pop(1);
          },
        ),
      ],
    ).then<int>((value) {
      if (value == 1) {
        function();
      }
      return value;
    });
  }

  static Future<void> sliderConfirm({
    @required BuildContext context,
    Widget content,
    @required Function function,
  }) async {
    await baseMenu<int>(
      context: context,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(24),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.subhead,
            child: content ?? Text(I18N.of("继续该操作吗？")),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: SliderConfirm(
            function: () => Navigator.of(context).pop(1),
          ),
        ),
      ],
      contentPadding: EdgeInsets.all(0),
    ).then<int>((value) {
      if (value == 1) {
        function();
      }
      return value;
    });
  }

  static Future<void> attention({
    @required BuildContext context,
    Widget content,
  }) async {
    await baseAlertMenu(
      context: context,
      content: content,
    );
  }

  static Future<T> baseAlertMenu<T>({
    @required BuildContext context,
    Widget title,
    Widget content,
    List<Widget> actions,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title ?? Text(I18N.of("注意")),
        content: content ?? Text(I18N.of("注意")),
        actions: actions ??
            <Widget>[
              FlatButton(
                child: Text(I18N.of("确定")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
      ),
    );
  }

  static Future<T> baseMenu<T>({
    @required BuildContext context,
    Widget title,
    List<Widget> children,
    EdgeInsetsGeometry contentPadding,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: title ?? Text(I18N.of("注意")),
        children: children ?? [Text(I18N.of("注意"))],
        contentPadding:
            contentPadding ?? EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
      ),
    );
  }

  static Future<String> datePicker({
    @required BuildContext context,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 3650)),
      firstDate: DateTime.now().subtract(Duration(days: 36500)),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    ).then((onValue) {
      if (onValue != null) {
        return onValue.toIso8601String().toString();
      }
      return null;
    });
  }

  static Future<String> userInfo({
    @required BuildContext context,
    @required int uid,
  }) async {
    return await baseMenu(
      context: context,
      title: Text(I18N.of("信息")),
      children: <Widget>[
        UserInfoPopMenuContext(uid),
      ],
      contentPadding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
    );
  }

  static Future<void> ban(BuildContext context) async {
    await baseMenu(
      context: context,
      contentPadding: EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.warning,
              size: 80,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            Container(),
            Container(
              child: Text(
                I18N.of("您的账号由于存在恶意刷金币行为已被系统限制金币获取"),
                maxLines: 3,
              ),
              width: 200,
            ),
          ],
        ),
      ],
    );
  }

  static Future<void> coinAdd({
    @required BuildContext context,
    @required int addedCoins,
  }) async {
    await baseMenu(
      context: context,
      title: Text(I18N.of("打卡成功")),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.monetization_on,
              size: 80,
              color: Theme.of(context).accentColor,
            ),
            Text(
              " + ",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            Text(
              " ${addedCoins.toString()} ",
              style: TextStyle(
                fontSize: 60,
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
        Container(height: 10,),
        Center(
          child: Text(
            "${Provider.of<UserProvider>(context, listen: false).coins} -> ${Provider.of<UserProvider>(context, listen: false).coins + addedCoins}",
            style: TextStyle(
              color: Theme.of(context).unselectedWidgetColor,
            ),
          ),
        ),
      ],
    );
  }
}
