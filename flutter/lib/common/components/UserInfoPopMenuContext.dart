import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/network/Repository.dart';
import 'package:provider/provider.dart';

class UserInfoPopMenuContext extends StatefulWidget {
  final int uid;

  UserInfoPopMenuContext(this.uid);

  @override
  _UserInfoPopMenuContextState createState() => _UserInfoPopMenuContextState();
}

class _UserInfoPopMenuContextState extends State<UserInfoPopMenuContext> {
  List<int> photo;
  Map userInfo;
  int coins;

  bool isFollowed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    photo = null;
    userInfo = {};
    coins = -1;
    isFollowed = false;
    getData();
  }

  Future<void> getData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    isFollowed = await Repository.getInstance().getFollowState(
        context, userProvider.token, userProvider.uid, widget.uid);
    setState(() {});
    userInfo = await Repository.getInstance().getUserInfo(widget.uid);
    setState(() {});
    coins = await Repository.getInstance().getCoin(widget.uid);
    setState(() {});
    photo = await Repository.getInstance().getPhoto(widget.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double size = 80;
    return Column(
      children: <Widget>[
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            photo == null || photo.isEmpty
                ? Icon(
                    Icons.account_circle,
                    size: size,
                    color: Theme.of(context).unselectedWidgetColor,
                  )
                : ClipOval(
                    child: Image.memory(
                      photo,
                      width: size,
                      height: size,
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${I18N.of("用户名")}: ", style: TextStyle(height: 1.5)),
                Text("${I18N.of("生日")}: ", style: TextStyle(height: 1.5)),
                Text("${I18N.of("性别")}: ", style: TextStyle(height: 1.5)),
                Text("${I18N.of("金币")}: ", style: TextStyle(height: 1.5)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                userInfo == null
                    ? Text(I18N.of("用户名"))
                    : Text(userInfo["userName"].toString(),
                        style: TextStyle(height: 1.5)),
                userInfo == null
                    ? Text(I18N.of("生日"))
                    : Text(userInfo["birthday"].toString(),
                        style: TextStyle(height: 1.5)),
                userInfo == null
                    ? Text(I18N.of("性别"))
                    : Text(I18N.of(userInfo["gender"].toString()),
                        style: TextStyle(height: 1.5)),
                Text(coins.toString(), style: TextStyle(height: 1.5)),
              ],
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
              color: isFollowed
                  ? Theme.of(context).unselectedWidgetColor
                  : Theme.of(context).accentColor,
              textColor: Theme.of(context).cardColor,
              child: isFollowed ? Text(I18N.of("取消关注")) : Text(I18N.of("关注")),
              onPressed: () async {
                UserProvider userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                String res = await Repository.getInstance().follow(
                    context, userProvider.token, userProvider.uid, widget.uid);
                if (res != null) {
                  isFollowed = !isFollowed;
                  setState(() {});
                  await PopMenus.attention(context: context,content: Text(res == "followed" ? I18N.of("关注成功") : I18N.of("取消关注成功")));
                  Navigator.of(context).pop(res);
                }
              },
            ),
//            RaisedButton(
//              color: Theme.of(context).accentColor,
//              textColor: Theme.of(context).cardColor,
//              child: Text(I18N.of("私信")),
//              onPressed: () {},
//            ),
          ],
        ),
      ],
    );
  }
}
