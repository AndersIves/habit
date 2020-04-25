import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/view/drawer/community/FollowedPage.dart';
import 'package:habit/view/drawer/community/RankingListPage.dart';
import 'package:habit/view/drawer/community/SearchUserPage.dart';
import 'package:habit/view/drawer/setting/LanguageSetPage.dart';
import 'package:habit/view/drawer/setting/SettingPage.dart';
import 'package:habit/view/drawer/setting/ThemeSetPage.dart';
import 'package:habit/view/drawer/shop/ShopPage.dart';
import 'package:habit/view/drawer/user/UserPage.dart';
import 'package:provider/provider.dart';

class HomePageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(top: 36, bottom: 10, left: 16, right: 16),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          I18N.of("欢迎"),
                          style: Theme.of(context).textTheme.headline.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Text(
                          I18N.of("来到"),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Text(
                          "Habit",
                          style: Theme.of(context).textTheme.title.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        userProvider.photo == null
                            ? Icon(
                                Icons.account_circle,
                                size: 70,
                                color: Theme.of(context).colorScheme.onPrimary,
                              )
                            : ClipOval(
                                child: Image.memory(
                                  userProvider.photo,
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                        Container(height: 10),
                        Text(
                          userProvider.userName != null &&
                                  userProvider.userName != null
                              ? userProvider.userName
                              : I18N.of("未登录"),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "${I18N.of("今日状态")}: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                            ),
                            Icon(
                              dataProvider.todayEvaluate <= 4
                                  ? Icons.sentiment_dissatisfied
                                  : dataProvider.todayEvaluate <= 9
                                      ? Icons.sentiment_neutral
                                      : Icons.sentiment_satisfied,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.account_box),
                  title: Text(I18N.of("用户")),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => UserPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.trending_up),
                  title: Text(I18N.of("排行榜")),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => RankingListPage()));
                  },
                ),
                userProvider.token == null
                    ? Container()
                    : ListTile(
                        leading: Icon(Icons.face),
                        title: Text(I18N.of("我的关注")),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => FollowedPage()));
                        },
                      ),
                userProvider.token == null
                    ? Container()
                    : ListTile(
                        leading: Icon(Icons.search),
                        title: Text(I18N.of("搜索用户")),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SearchUserPage()));
                        },
                      ),
                ListTile(
                  leading: Icon(Icons.store),
                  title: Text(I18N.of("商城")),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => ShopPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(I18N.of("设置")),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => SettingPage()));
                  },
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: InkWell(
                child: Text(
                  "@2020 ZXZhang All rights reserved.",
                  style: Theme.of(context).textTheme.caption,
                ),
                onTap: () {
                  PopMenus.baseMenu(
                    context: context,
                    title: Text("About"),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(25),
                        child: Text(
                          "本软件由张子玄独立设计、开发完成\n移动端使用Flutter开发\n后端使用SpringBoot开发\n使用docker在阿里云部署",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            "@2020 ZXZhang All rights reserved.",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ],
      ),
    );
  }
}
