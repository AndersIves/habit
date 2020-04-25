import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/network/Repository.dart';
import 'package:habit/view/drawer/user/sign/ModifyPwdPage.dart';
import 'package:habit/view/drawer/user/sign/SignUpPage.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInPageService>(
            create: (_) => SignInPageService(context)),
        ChangeNotifierProvider<SignInPageModel>(
            create: (_) => SignInPageModel(context)),
      ],
      child: _SignInPageView(),
    );
  }
}

// model
class SignInPageModel extends BaseModel {
  SignInPageModel(BuildContext context) : super(context);

  bool isRequesting;
  bool isPwdVisible;

  GlobalKey formKey;

  TextEditingController emailController;
  TextEditingController pwdController;

  @override
  void init(BuildContext context) {
    // TODO: implement init
    super.init(context);
    isRequesting = false;
    isPwdVisible = false;
    formKey = new GlobalKey<FormState>();
    emailController = new TextEditingController();
    emailController.text =
        Provider.of<UserProvider>(context, listen: false).email ?? "";
    pwdController = new TextEditingController();
  }
}

// service
class SignInPageService extends BaseService {
  SignInPageService(BuildContext context) : super(context);

  String validatorEmail(String v) {
    if (v.trim().isEmpty) {
      return I18N.of("邮箱不能为空");
    } else {
      return null;
    }
  }

  void pwdChangeVisible(BuildContext context) {
    SignInPageModel model =
        Provider.of<SignInPageModel>(context, listen: false);
    model.isPwdVisible = !model.isPwdVisible;
    model.refresh();
  }

  String validatorPwd(String v) {
    if (v.trim().isEmpty) {
      return I18N.of("密码不能为空");
    } else {
      return null;
    }
  }

  Future<void> signIn(BuildContext context) async {
    SignInPageModel model =
        Provider.of<SignInPageModel>(context, listen: false);
    model.isRequesting = true;
    model.refresh();
    if ((model.formKey.currentState as FormState).validate()) {
      Map map = await Repository.getInstance().signIn(
        context,
        model.emailController.text,
        model.pwdController.text,
      );
      if (map != null && map.isNotEmpty) {
        try {
          int uid = map["uid"];
          String token = map["token"];
          String email = model.emailController.text;
          Map userInfo = await Repository.getInstance().getUserInfo(uid);
          String userName = userInfo["userName"];
          String gender = userInfo["gender"];
          String birthday = userInfo["birthday"];
          int coins = await Repository.getInstance().getCoin(uid);
          List<int> photo = await Repository.getInstance().getPhoto(uid);
          UserProvider userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.uid = uid;
          userProvider.token = token;
          userProvider.email = email;
          userProvider.userName = userName;
          userProvider.gender = gender;
          userProvider.birthday = birthday;
          userProvider.coins = coins;
          userProvider.photo = photo.isEmpty ? null : photo;
          userProvider.store();
          userProvider.refresh();
        } catch (e) {
          debugPrint(e.toString());
          await PopMenus.attention(
              context: context, content: Text(I18N.of("连接失败")));
        }
        await PopMenus.attention(
            context: context, content: Text(I18N.of("登陆成功")));
        Navigator.of(context).pop();
      }
    }
    model.isRequesting = false;
    model.refresh();
  }

  Future<void> toPwdResetPage(BuildContext context) async {
    SignInPageModel model =
        Provider.of<SignInPageModel>(context, listen: false);
    model.emailController.text = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ModifyPwdPage()));
    model.refresh();
  }

  Future<void> toSignUpPage(BuildContext context) async {
    SignInPageModel model =
        Provider.of<SignInPageModel>(context, listen: false);
    model.emailController.text = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => SignUpPage()));
    model.refresh();
  }
}

// view
class _SignInPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SignInPageService service =
        Provider.of<SignInPageService>(context, listen: false);
    SignInPageModel model = Provider.of<SignInPageModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("登录")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            model.isRequesting ? LinearProgressIndicator() : Container(),
            Center(
              child: Icon(
                Icons.account_circle,
                size: 220,
                color: Theme.of(context).unselectedWidgetColor,
              ),
            ),
            Form(
              key: model.formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: model.emailController,
                    enabled: !model.isRequesting,
                    decoration: InputDecoration(
                      labelText: I18N.of("邮箱"),
                      hintText: I18N.of("请输入您的邮箱"),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (v) => service.validatorEmail(v),
                  ),
                  TextFormField(
                    controller: model.pwdController,
                    enabled: !model.isRequesting,
                    obscureText: !model.isPwdVisible,
                    decoration: InputDecoration(
                      labelText: I18N.of("密码"),
                      hintText: I18N.of("请输入您的密码"),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          model.isPwdVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => service.pwdChangeVisible(context),
                      ),
                    ),
                    validator: (v) => service.validatorPwd(v),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: RaisedButton(
                child: Text(
                  I18N.of("登录"),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                  ),
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed:
                    model.isRequesting ? null : () => service.signIn(context),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text(I18N.of("忘记密码？")),
                  onPressed: model.isRequesting
                      ? null
                      : () => service.toPwdResetPage(context),
                ),
                FlatButton(
                  child: Text(I18N.of("快速注册")),
                  onPressed: model.isRequesting
                      ? null
                      : () => service.toSignUpPage(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
