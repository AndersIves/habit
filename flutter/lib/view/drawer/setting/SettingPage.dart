import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/view/drawer/setting/DataManagementPage.dart';
import 'package:habit/view/drawer/setting/DebugPage.dart';
import 'package:habit/view/drawer/setting/NotificationSetPage.dart';
import 'package:habit/view/drawer/setting/SignTimeSetPage.dart';
import 'package:provider/provider.dart';

import 'LanguageSetPage.dart';
import 'ThemeSetPage.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("设置")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Icon(
              Icons.settings,
              size: 150,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text(I18N.of("通知开关")),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => NotificationSetPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.timer),
              title: Text(I18N.of("打卡时段")),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SignTimeSetPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.translate),
              title: Text(I18N.of("语言")),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => LanguageSetPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text(I18N.of("主题")),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ThemeSetPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.folder_special),
              title: Text(I18N.of("数据管理")),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => DataManagementPage()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton:
          Provider.of<UserProvider>(context).email == "13895637677@126.com" && Provider.of<UserProvider>(context).userName == "开发者本尊"
              ? FloatingActionButton(
                  child: Icon(Icons.bug_report),
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => DebugPage())),
                ):null
    );
  }
}
