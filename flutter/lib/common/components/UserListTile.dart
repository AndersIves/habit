import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/UserInfoPopMenuContext.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/network/Repository.dart';
import 'package:provider/provider.dart';

import 'PopMenus.dart';

class UserListTile extends StatefulWidget {
  final int uid;
  final Widget trailing;
  final Function onPress;

  UserListTile({@required this.uid, this.onPress, this.trailing});

  @override
  _UserListTileState createState() => _UserListTileState();
}

class _UserListTileState extends State<UserListTile> {
  List<int> photo;
  Map userInfo;
  int coins;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    photo = null;
    userInfo = {};
    coins = -1;
    getData();
  }

  Future<void> getData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (widget.uid == userProvider.uid) {
      userInfo["userName"] = userProvider.userName;
      photo = userProvider.photo;
      coins = userProvider.coins;
    } else {
      userInfo = await Repository.getInstance().getUserInfo(widget.uid);
      setState(() {});
      coins = await Repository.getInstance().getCoin(widget.uid);
      setState(() {});
      photo = await Repository.getInstance().getPhoto(widget.uid);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double previewSize = 50;
    return ListTile(
      leading: photo == null || photo.isEmpty
          ? Icon(
              Icons.account_circle,
              size: previewSize,
              color: Theme.of(context).unselectedWidgetColor,
            )
          : ClipOval(
              child: Image.memory(
                photo,
                width: previewSize,
                height: previewSize,
              ),
            ),
      title: userInfo == null
          ? Text(I18N.of("用户名"))
          : Text(
              userInfo["userName"].toString(),
              style: widget.uid !=
                  Provider.of<UserProvider>(context, listen: false).uid ? null : TextStyle(
                decoration: TextDecoration.underline,
                color: Theme.of(context).accentColor,
              ),
            ),
      subtitle: Text("${I18N.of("金币")} : ${coins.toString()}"),
      trailing: widget.trailing ?? Icon(Icons.info_outline),
      onTap: Provider.of<UserProvider>(context, listen: false).token == null ? null:  widget.onPress,
    );
  }
}
