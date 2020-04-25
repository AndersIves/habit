import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/VerificationUtils.dart';
import 'package:habit/network/Repository.dart';
import 'package:provider/provider.dart';

class ModifyPwdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ModifyPwdPageService>(
            create: (_) => ModifyPwdPageService(context)),
        ChangeNotifierProvider<ModifyPwdPageModel>(
            create: (_) => ModifyPwdPageModel(context)),
      ],
      child: _ModifyPwdPageView(),
    );
  }
}

// model
class ModifyPwdPageModel extends BaseModel {
  ModifyPwdPageModel(BuildContext context) : super(context);

  bool isRequesting;
  bool isPwdVisible;

  int counter;

  GlobalKey emailFormKey = new GlobalKey<FormState>();
  GlobalKey pwdFormKey = new GlobalKey<FormState>();

  TextEditingController emailController;
  TextEditingController authCodeController;
  TextEditingController pwdController;
  TextEditingController pwdRepeatController;

  Timer timer;

  @override
  void init(BuildContext context) {
    // TODO: implement init
    super.init(context);
    isRequesting = false;
    isPwdVisible = false;
    counter = 0;

    emailFormKey = new GlobalKey<FormState>();
    pwdFormKey = new GlobalKey<FormState>();

    emailController = new TextEditingController();
    emailController.text =
        Provider.of<UserProvider>(context, listen: false).email ?? "";
    authCodeController = new TextEditingController();
    pwdController = new TextEditingController();
    pwdRepeatController = new TextEditingController();
    timer = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }
}

// service
class ModifyPwdPageService extends BaseService {
  ModifyPwdPageService(BuildContext context) : super(context);

  String validatorEmail(String v) {
    if (VerifyUtils.isEmail(v)) {
      return null;
    } else {
      return I18N.of("邮箱格式有误");
    }
  }

  String validatorPwd(String v) {
    if (VerifyUtils.isPassword(v)) {
      return null;
    } else {
      return I18N.of("字母开头，必须包含大小写字母，可以包含字母、数字、特殊符号\n长度为8~16位");
    }
  }

  String validatorPwdRepeat(BuildContext context) {
    ModifyPwdPageModel model =
        Provider.of<ModifyPwdPageModel>(context, listen: false);
    if (model.pwdController.text == model.pwdRepeatController.text) {
      return null;
    } else {
      return I18N.of("两次输入不一致");
    }
  }

  void pwdChangeVisible(BuildContext context) {
    ModifyPwdPageModel model =
        Provider.of<ModifyPwdPageModel>(context, listen: false);
    model.isPwdVisible = !model.isPwdVisible;
    model.refresh();
  }

  Future<void> sendAuthCode(BuildContext context) async {
    ModifyPwdPageModel model =
        Provider.of<ModifyPwdPageModel>(context, listen: false);
    model.isRequesting = true;
    model.refresh();
    if ((model.emailFormKey.currentState as FormState).validate()) {
      bool isSuccess = await Repository.getInstance().sendAuthCode(
        context,
        model.emailController.text,
        "RESET_PWD",
      );
      if (isSuccess) {
        startCounter(context);
      }
    }
    model.isRequesting = false;
    model.refresh();
  }

  void startCounter(BuildContext context) {
    ModifyPwdPageModel model =
        Provider.of<ModifyPwdPageModel>(context, listen: false);
    model.counter = 60;
    model.refresh();
    model.timer = Timer.periodic(Duration(seconds: 1), (t) {
      model.counter--;
      model.refresh();
      if (model.counter == 0) {
        model.timer.cancel();
      }
    });
  }

  Future<void> pwdReset(BuildContext context) async {
    ModifyPwdPageModel model =
        Provider.of<ModifyPwdPageModel>(context, listen: false);
    model.isRequesting = true;
    model.refresh();
    if ((model.pwdFormKey.currentState as FormState).validate()) {
      bool isSuccess = await Repository.getInstance().resetPwd(
        context,
        model.authCodeController.text,
        model.emailController.text,
        model.pwdController.text,
      );
      if (isSuccess) {
        Navigator.of(context).pop(model.emailController.text);
      }
    }
    model.isRequesting = false;
    model.refresh();
  }
}

// view
class _ModifyPwdPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ModifyPwdPageService service =
        Provider.of<ModifyPwdPageService>(context, listen: false);
    ModifyPwdPageModel model =
        Provider.of<ModifyPwdPageModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("重置密码")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            model.isRequesting ? LinearProgressIndicator() : Container(),
            Center(
              child:
              Icon(
                Icons.refresh,
                size: 220,
                color: Theme.of(context).unselectedWidgetColor,
              ),
            ),
            Form(
              key: model.emailFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: model.emailController,
                    enabled: !model.isRequesting &&
                        Provider.of<UserProvider>(context, listen: false)
                                .token ==
                            null,
                    decoration: InputDecoration(
                      labelText: I18N.of("邮箱"),
                      hintText: I18N.of("请输入您注册时的邮箱"),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (v) => service.validatorEmail(v),
                  ),
                  TextFormField(
                    controller: model.authCodeController,
                    enabled: !model.isRequesting,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: I18N.of("验证码"),
                      hintText: I18N.of("请输入6位验证码"),
                      prefixIcon: Icon(Icons.security),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: RaisedButton(
                          child: Text(
                            I18N.of("获取验证码") +
                                ((model.counter != 0)
                                    ? " ${model.counter}"
                                    : ""),
                            style: TextStyle(
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: model.isRequesting || model.counter != 0
                              ? null
                              : () => service.sendAuthCode(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: model.pwdFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: model.pwdController,
                    enabled: !model.isRequesting,
                    obscureText: !model.isPwdVisible,
                    decoration: InputDecoration(
                      labelText: I18N.of("新密码"),
                      hintText: I18N.of("请输入您的新密码"),
                      prefixIcon: Icon(Icons.lock_outline),
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
                  TextFormField(
                    controller: model.pwdRepeatController,
                    enabled: !model.isRequesting,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: I18N.of("重复密码"),
                      hintText: I18N.of("请重复输入您的新密码"),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (v) => service.validatorPwdRepeat(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: RaisedButton(
                child: Text(
                  I18N.of("提交"),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                  ),
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed:
                    model.isRequesting ? null : () => service.pwdReset(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
