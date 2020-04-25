import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:habit/common/LocalData.dart';
import 'package:habit/view/HomePage.dart';

class UserProvider extends ChangeNotifier {
  String token;

  int uid;
  String email;
  String userName;
  String gender;
  String birthday;
  Uint8List photo;
  int coins;

  void init() {
    load();
    debugPrint("""init AccountProvider to:
      token = $token
      uid = $uid
      email = $email
      userName = $userName
      gender = $gender
      birthday = $birthday
      photo = ${photo != null ? "notNull" : "null"}
      coins = $coins""");
  }

  void store() {
    LocalData.getInstance().setString("token", token);
    LocalData.getInstance().setInt("uid", uid);
    LocalData.getInstance().setString("email", email);
    LocalData.getInstance().setString("userName", userName);
    LocalData.getInstance().setString("gender", gender);
    LocalData.getInstance().setString("birthday", birthday);
    LocalData.getInstance().setString(
        "photo", photo == null ? null : Base64Encoder().convert(photo));
    LocalData.getInstance().setInt("coins", coins);
  }

  void load() {
    token = LocalData.getInstance().getString("token");
    uid = LocalData.getInstance().getInt("uid");
    email = LocalData.getInstance().getString("email");
    userName = LocalData.getInstance().getString("userName");
    gender = LocalData.getInstance().getString("gender");
    birthday = LocalData.getInstance().getString("birthday");
    String listString = LocalData.getInstance().getString("photo");
    if (listString == null) {
      photo = null;
    } else {
      photo = Base64Decoder().convert(listString);
    }
    coins = LocalData.getInstance().getInt("coins");
  }

  Future<void> cleanDataAndBackToHome(BuildContext context) async {
    token = null;

    uid = null;
//    email = null;
    userName = null;
    gender = null;
    birthday = null;
    photo = null;
    coins = null;
    store();
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
      (route) => route == null,
    );
    refresh();
  }

  void refresh() {
    store();
    notifyListeners();
  }
}
