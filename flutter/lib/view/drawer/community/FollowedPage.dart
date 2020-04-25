import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/components/UserInfoPopMenuContext.dart';
import 'package:habit/common/components/UserListTile.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/network/Repository.dart';
import 'package:habit/view/drawer/community/SearchUserPage.dart';
import 'package:provider/provider.dart';

class FollowedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FollowedPageService>(
            create: (_) => FollowedPageService(context)),
        ChangeNotifierProvider<FollowedPageModel>(
            create: (_) => FollowedPageModel(context)),
      ],
      child: _FollowedPageView(),
    );
  }
}

// model
class FollowedPageModel extends BaseModel {
  FollowedPageModel(BuildContext context) : super(context);

  bool isRequesting;

  List data;

  @override
  void init(BuildContext context) {
    // TODO: implement init
    super.init(context);
    isRequesting = true;
    data = [];
  }

  @override
  Future<void> asyncInit(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    data.add(userProvider.uid);
    data.addAll(await Repository.getInstance()
        .getFollowList(context, userProvider.token, userProvider.uid));
    isRequesting = false;
    refresh();
  }
}

// service
class FollowedPageService extends BaseService {
  FollowedPageService(BuildContext context) : super(context);

  Future<void> onUnFollowed(BuildContext context, int uid) async {
    FollowedPageModel model =
        Provider.of<FollowedPageModel>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String res = await PopMenus.userInfo(context: context, uid: uid);
    if (res != null) {
      model.data.remove(uid);
      model.isRequesting = true;
      model.refresh();
      model.data.clear();
      model.data.add(userProvider.uid);
      model.data.addAll(await Repository.getInstance()
          .getFollowList(context, userProvider.token, userProvider.uid));
      model.isRequesting = false;
      model.refresh();
    }
  }
}

// view
class _FollowedPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FollowedPageService service =
        Provider.of<FollowedPageService>(context, listen: false);
    FollowedPageModel model =
        Provider.of<FollowedPageModel>(context, listen: true);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("我的关注")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            model.isRequesting ? LinearProgressIndicator() : Container(),
            Column(
              children: model.data.map((i) {
                return UserListTile(
                  uid: i,
                  trailing: i == userProvider.uid
                      ? null
                      : Text("${I18N.of("排名")}: ${model.data.indexOf(i)}"),
                  onPress: () => service.onUnFollowed(context, i),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
