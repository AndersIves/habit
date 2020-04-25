import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/view/drawer/setting/DataManagementPage.dart';
import 'package:habit/view/drawer/user/setting/UserSettingPage.dart';
import 'package:habit/view/drawer/user/sign/SignInPage.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("用户")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: userProvider.token == null
              ? unSignInWidgets(context)
              : signInWidgets(context),
        ),
      ),
    );
  }

  List<Widget> unSignInWidgets(BuildContext context) {
    return [
      Center(
        child: Icon(
          Icons.account_circle,
          size: 150,
          color: Theme.of(context).unselectedWidgetColor,
        ),
      ),
      Center(
        child: Text(
          I18N.of("未登录"),
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.input),
        title: Text(I18N.of("登录")),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => SignInPage()));
        },
      ),
    ];
  }

  List<Widget> signInWidgets(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    return [
      Center(
        child: userProvider.photo == null
            ? Icon(
                Icons.account_circle,
                size: 150,
                color: Theme.of(context).unselectedWidgetColor,
              )
            : ClipOval(
                child: Image.memory(
                  userProvider.photo,
                  width: 150,
                  height: 150,
                ),
              ),
      ),
      ListTile(
        leading: Icon(Icons.account_box),
        title: Text(I18N.of("用户名")),
        trailing: Text(ConvertUtils.packString(userProvider.userName)),
      ),
      ListTile(
        leading: Icon(Icons.format_list_numbered),
        title: Text(I18N.of("ID")),
        trailing: Text(userProvider.uid.toString()),
      ),
      ListTile(
        leading: Icon(Icons.email),
        title: Text(I18N.of("邮箱")),
        trailing: Text(userProvider.email.toString()),
      ),
      ListTile(
        leading: Icon(Icons.supervisor_account),
        title: Text(I18N.of("性别")),
        trailing: Text(ConvertUtils.packString(I18N.of(userProvider.gender))),
      ),
      ListTile(
        leading: Icon(Icons.cake),
        title: Text(I18N.of("生日")),
        trailing: Text(ConvertUtils.packString(userProvider.birthday)),
      ),
      ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(I18N.of("金币")),
        trailing: Text(userProvider.coins.toString()),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text(I18N.of("用户设置")),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => UserSettingPage()));
        },
      ),
    ];
  }
}
