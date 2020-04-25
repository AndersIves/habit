import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/VerificationUtils.dart';
import 'package:habit/network/Repository.dart';
import 'package:habit/view/drawer/user/setting/CropImagePage.dart';
import 'package:habit/view/drawer/user/sign/ModifyPwdPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserSettingPageService>(
            create: (_) => UserSettingPageService(context)),
        ChangeNotifierProvider<UserSettingPageModel>(
            create: (_) => UserSettingPageModel(context)),
      ],
      child: _UserSettingPageView(),
    );
  }
}

// model
class UserSettingPageModel extends BaseModel {
  UserSettingPageModel(BuildContext context) : super(context);

  bool isRequesting;

  @override
  void init(BuildContext context) {
    // TODO: implement init
    super.init(context);
    isRequesting = false;
  }
}

// service
class UserSettingPageService extends BaseService {
  UserSettingPageService(BuildContext context) : super(context);

  Future<void> modifyAndUploadUserInfo(
    BuildContext context, {
    String userName,
    String gender,
    String birthday,
  }) async {
    UserSettingPageModel model =
        Provider.of<UserSettingPageModel>(context, listen: false);
    model.isRequesting = true;
    model.refresh();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    bool isSuccess = await Repository.getInstance().modifyUserInfo(
      context,
      userProvider.token,
      userProvider.uid,
      userName,
      gender,
      birthday,
    );
    if (isSuccess) {
      userProvider.userName = userName ?? userProvider.userName;
      userProvider.gender = gender ?? userProvider.gender;
      userProvider.birthday = birthday ?? userProvider.birthday;
      userProvider.refresh();
      await PopMenus.attention(
          context: context, content: Text(I18N.of("修改成功")));
    }
    model.isRequesting = false;
    model.refresh();
  }

  Future<void> modifyAndUploadPhoto(
      BuildContext context, List<int> photo) async {
    UserSettingPageModel model =
        Provider.of<UserSettingPageModel>(context, listen: false);
    model.isRequesting = true;
    model.refresh();

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    bool isSuccess = await Repository.getInstance()
        .uploadPhoto(context, userProvider.token, userProvider.uid, photo);
    if (isSuccess) {
      userProvider.photo = Uint8List.fromList(photo);
      userProvider.store();
      userProvider.refresh();
      await PopMenus.attention(
          context: context, content: Text(I18N.of("修改成功")));
    }

    model.isRequesting = false;
    model.refresh();
  }

  Future<void> modifyUserPhoto(BuildContext context) async {
    List<int> res = await PopMenus.baseMenu(
      context: context,
      title: Text(I18N.of("修改头像")),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.camera),
          title: Text(I18N.of("拍照")),
          trailing: Icon(Icons.chevron_right),
          onTap: () async =>
              Navigator.of(context).pop(await takePhoto(context)),
        ),
        ListTile(
          leading: Icon(Icons.photo),
          title: Text(I18N.of("从相册中选择")),
          trailing: Icon(Icons.chevron_right),
          onTap: () async =>
              Navigator.of(context).pop(await pickPhoto(context)),
        ),
      ],
    );
    if (res != null) {
      await modifyAndUploadPhoto(context, res);
    }
  }

  Future<List<int>> takePhoto(BuildContext context) async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      List<int> res = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => CropImagePage(file)));
      if (res != null && res.isNotEmpty) {
        return res;
      }
    }
    return null;
  }

  Future<List<int>> pickPhoto(BuildContext context) async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      List<int> res = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => CropImagePage(file)));
      if (res != null && res.isNotEmpty) {
        return res;
      }
    }
    return null;
  }

  Future<void> modifyUserName(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    TextEditingController controller = new TextEditingController();
    controller.text = userProvider.userName;
    String res = await PopMenus.baseMenu<String>(
      context: context,
      title: Text(I18N.of("修改用户名")),
      children: <Widget>[
        TextFormField(
          autovalidate: true,
          validator: (v) {
            if (VerifyUtils.isUserName(v)) {
              return null;
            }
            return I18N.of("长度为2-10个不包括任何符号的字符");
          },
          controller: controller,
          decoration: InputDecoration(
            labelText: I18N.of("用户名"),
            hintText: I18N.of("请输入新用户名"),
          ),
        ),
        FlatButton(
          child: Text(I18N.of("确定")),
          onPressed: () {
            if (VerifyUtils.isUserName(controller.text)) {
              Navigator.of(context).pop(controller.text.trim());
            }
          },
        ),
      ],
      contentPadding: EdgeInsets.all(16),
    );
    if (res != null && res != userProvider.userName) {
      await modifyAndUploadUserInfo(context, userName: res);
    }
  }

  void signOut(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    PopMenus.confirm(
      context: context,
      function: () async {
        await userProvider.cleanDataAndBackToHome(context);
      },
    );
  }

  Future<void> modifyUserGender(BuildContext context) async {
    String res = await PopMenus.baseMenu<String>(
      context: context,
      title: Text(I18N.of("修改用户名")),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.tag_faces),
          title: Text(I18N.of("男")),
          trailing: Icon(Icons.arrow_right),
          onTap: () => Navigator.of(context).pop("男"),
        ),
        ListTile(
          leading: Icon(Icons.face),
          title: Text(I18N.of("女")),
          trailing: Icon(Icons.arrow_right),
          onTap: () => Navigator.of(context).pop("女"),
        ),
      ],
      contentPadding: EdgeInsets.all(16),
    );
    if (res != null) {
      await modifyAndUploadUserInfo(context, gender: res);
    }
  }

  Future<void> modifyUserBirthday(BuildContext context) async {
    String res = await PopMenus.datePicker(context: context);
    if (res != null) {
      await modifyAndUploadUserInfo(context, birthday: res.substring(0, 10));
    }
  }

  void toModifyPwdPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ModifyPwdPage()));
  }
}

// view
class _UserSettingPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserSettingPageService service =
        Provider.of<UserSettingPageService>(context, listen: false);
    UserSettingPageModel model =
        Provider.of<UserSettingPageModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("用户设置")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            model.isRequesting ? LinearProgressIndicator() : Container(),
            Icon(
              Icons.settings,
              size: 150,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_a_photo),
              title: Text(I18N.of("修改头像")),
              trailing: Icon(Icons.chevron_right),
              onTap: model.isRequesting
                  ? null
                  : () => service.modifyUserPhoto(context),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text(I18N.of("修改用户名")),
              trailing: Icon(Icons.chevron_right),
              onTap: model.isRequesting
                  ? null
                  : () => service.modifyUserName(context),
            ),
            ListTile(
              leading: Icon(Icons.supervisor_account),
              title: Text(I18N.of("修改性别")),
              trailing: Icon(Icons.chevron_right),
              onTap: model.isRequesting
                  ? null
                  : () => service.modifyUserGender(context),
            ),
            ListTile(
              leading: Icon(Icons.cake),
              title: Text(I18N.of("修改生日")),
              trailing: Icon(Icons.chevron_right),
              onTap: model.isRequesting
                  ? null
                  : () => service.modifyUserBirthday(context),
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text(I18N.of("重设密码")),
              trailing: Icon(Icons.chevron_right),
              onTap: model.isRequesting
                  ? null
                  : () => service.toModifyPwdPage(context),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(I18N.of("登出")),
              trailing: Icon(Icons.chevron_right),
              onTap: model.isRequesting ? null : () => service.signOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
