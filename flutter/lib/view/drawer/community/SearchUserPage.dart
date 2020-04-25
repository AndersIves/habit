import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/components/UserListTile.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/VerificationUtils.dart';
import 'package:habit/network/Repository.dart';
import 'package:provider/provider.dart';

class SearchUserPage extends StatefulWidget {
  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  bool isRequesting;
  List res;

  TextEditingController nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRequesting = false;
    res = [];
    nameController = new TextEditingController();
    nameController.text = Provider.of<UserProvider>(context, listen: false).userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("搜索用户")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            TextFormField(
              autovalidate: true,
              validator: (v) {
                if (VerifyUtils.isUserName(v)) {
                  return null;
                }
                return I18N.of("长度为2-10个不包括任何符号的字符");
              },
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.perm_contact_calendar),
                labelText: I18N.of("用户名"),
                hintText: I18N.of("输入用户名查询"),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: RaisedButton(
                    child: Text(
                      I18N.of("搜索"),
                      style: TextStyle(
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: isRequesting
                        ? null
                        : () async {
                            isRequesting = true;
                            setState(() {});
                            res.clear();
                            if (VerifyUtils.isUserName(nameController.text)) {
                              res = await Repository.getInstance()
                                  .getUserInfoLikeUserName(
                                  context, nameController.text);
                            }
                            isRequesting = false;
                            setState(() {});
                          },
                  ),
                ),
              ),
            ),
            Column(
              children: res.map((i) {
                return UserListTile(
                  uid: i,
                  onPress: () async {
                    await PopMenus.userInfo(context: context, uid: i);
                  },
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
