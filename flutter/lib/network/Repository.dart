import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:provider/provider.dart';

import 'Api.dart';
import 'Status.dart';

class Repository {
  Dio _dio;

  Repository._() {
    if (_dio == null) {
      _dio = new Dio(
        BaseOptions(
          connectTimeout: 8000,
          receiveTimeout: 8000,
        ),
      );
    }
  }

  static Repository _repository;

  static Repository getInstance() {
    if (_repository == null) {
      _repository = new Repository._();
    }
    return _repository;
  }

  Future<bool> sendAuthCode(
    BuildContext context,
    String email,
    String purpose,
  ) async {
    Response response;
    try {
      response = await _dio.post(
        Api.authCode,
        data: {
          "email": email,
          "purpose": purpose,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("验证码发送成功，5分钟内有效")));
        return true;

      case Status.RES_REPEATED:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("该邮箱已存在")));
        break;

      case Status.RES_NOT_FOUND:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("该邮箱未注册")));
        break;

      case Status.CREATE_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("邮件发送失败")));
        break;
    }
    return false;
  }

  Future<bool> signUp(
    BuildContext context,
    String authCode,
    String email,
    String pwd,
  ) async {
    Response response;
    try {
      response = await _dio.post(
        "${Api.user}/",
        options: Options(
          headers: {
            "authCode": authCode,
          },
        ),
        data: {
          "email": email,
          "pwd": ConvertUtils.md5Encode(pwd),
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("注册成功")));
        return true;

      case Status.RES_NOT_MATCH:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("验证码错误或过期")));
        break;

      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return false;
  }

  Future<bool> resetPwd(
    BuildContext context,
    String authCode,
    String email,
    String pwd,
  ) async {
    Response response;
    try {
      response = await _dio.put(
        "${Api.user}/",
        options: Options(
          headers: {
            "authCode": authCode,
          },
        ),
        data: {
          "email": email,
          "pwd": ConvertUtils.md5Encode(pwd),
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("修改密码成功")));
        return true;

      case Status.RES_NOT_MATCH:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("验证码错误或过期")));
        break;

      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return false;
  }

  Future<Map> signIn(
    BuildContext context,
    String email,
    String pwd,
  ) async {
    Response response;
    try {
      response = await _dio.post(
        Api.token,
        data: {
          "email": email,
          "pwd": ConvertUtils.md5Encode(pwd),
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return response.data;

      case Status.RES_NOT_MATCH:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("邮箱或密码错误")));
        break;

      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return {};
  }

  Future<Map> getUserInfo(int uid) async {
    Response response;
    try {
      response = await _dio.get("${Api.user}/$uid/userInfo");
    } catch (e) {
      debugPrint(e.toString());
    }
    if (Status.of(response) == Status.OK) {
      return response.data;
    }
    return {};
  }

  Future<int> getCoin(int uid) async {
    Response response;
    try {
      response = await _dio.get("${Api.user}/$uid/coin");
    } catch (e) {
      debugPrint(e.toString());
    }
    if (Status.of(response) == Status.OK) {
      return response.data;
    }
    return null;
  }

  Future<List<int>> getPhoto(int uid) async {
    Response response;
    try {
      response = await _dio.get(
        "${Api.user}/$uid/userPhoto",
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    if (Status.of(response) == Status.OK) {
      return response.data;
    }
    return null;
  }

  Future<bool> uploadPhoto(
      BuildContext context, String token, int uid, List<int> photo) async {
    Response response;
    try {
      response = await _dio.put("${Api.user}/$uid/userPhoto",
          options: Options(
            headers: {
              "token": token,
            },
          ),
          data: {
            "photo": photo,
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return true;

      case Status.INVALID_AUTHORIZE:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("登录信息过期")));
        await Provider.of<UserProvider>(context, listen: false)
            .cleanDataAndBackToHome(context);
        break;

      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return false;
  }

  Future<bool> modifyUserInfo(
    BuildContext context,
    String token,
    int uid,
    String userName,
    String gender,
    String birthday,
  ) async {
    Response response;
    try {
      response = await _dio.put(
        "${Api.user}/$uid/userInfo",
        options: Options(
          headers: {
            "token": token,
          },
        ),
        data: {
          "userName": userName,
          "gender": gender,
          "birthday": birthday,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return true;

      case Status.INVALID_AUTHORIZE:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("登录信息过期")));
        await Provider.of<UserProvider>(context, listen: false)
            .cleanDataAndBackToHome(context);
        break;

      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return false;
  }

  Future<bool> getFollowState(
      BuildContext context, String token, int uid, int followUid) async {
    Response response;
    try {
      response = await _dio.get("${Api.community}/$uid/follow/$followUid",
          options: Options(
            headers: {
              "token": token,
            },
          ));
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return response.data;
      case Status.INVALID_AUTHORIZE:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("登录信息过期")));
        await Provider.of<UserProvider>(context, listen: false)
            .cleanDataAndBackToHome(context);
        break;
      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return false;
  }

  Future<String> follow(
      BuildContext context, String token, int uid, int followUid) async {
    Response response;
    try {
      response = await _dio.post(
        Api.follow,
        options: Options(
          headers: {
            "token": token,
          },
        ),
        data: {
          "uid": uid,
          "followUid": followUid,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return response.data;
      case Status.RES_NOT_ALLOW:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("不能关注自己")));
        break;
      case Status.INVALID_AUTHORIZE:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("登录信息过期")));
        await Provider.of<UserProvider>(context, listen: false)
            .cleanDataAndBackToHome(context);
        break;
      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return null;
  }

  Future<List> getFollowList(
      BuildContext context, String token, int uid) async {
    Response response;
    try {
      response = await _dio.get(
        Api.follow,
        options: Options(
          headers: {
            "token": token,
          },
        ),
        queryParameters: {
          "uid": uid,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return response.data;

      case Status.INVALID_AUTHORIZE:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("登录信息过期")));
        await Provider.of<UserProvider>(context, listen: false)
            .cleanDataAndBackToHome(context);
        break;

      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return [];
  }

  Future<List> getUserInfoLikeUserName(
      BuildContext context, String name) async {
    Response response;
    try {
      response = await _dio.get("${Api.user}/", queryParameters: {
        "name": name,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return response.data;
      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return [];
  }

  Future<List> getCoinTop(BuildContext context, int topCount) async {
    Response response;
    try {
      response = await _dio.get("${Api.community}/coinTop", queryParameters: {
        "topCount": topCount,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return response.data;
      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return [];
  }

  Future<List> getGoodsList(BuildContext context) async {
    Response response;
    try {
      response = await _dio.get(
        "${Api.shopping}/",
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return response.data;
      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return [];
  }

  Future<int> increaseCoin(BuildContext context, int uid, String token) async {
    Response response;
    try {
      response = await _dio.put(
        "${Api.user}/$uid/coin",
        options: Options(headers: {
          "token": token,
        }),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return response.data;
      case Status.INVALID_AUTHORIZE:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("登录信息过期")));
        await Provider.of<UserProvider>(context, listen: false)
            .cleanDataAndBackToHome(context);
        break;
      case Status.RES_NOT_ALLOW:
        await PopMenus.ban(context);
        Provider.of<UserProvider>(context, listen: false).coins = -666;
        Provider.of<UserProvider>(context, listen: false).refresh();
        break;
      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return null;
  }

  Future<bool> buyGoods(
      BuildContext context, String token, int uid, int goodsId) async {
    Response response;
    try {
      response = await _dio.post("${Api.shopping}/",
          options: Options(headers: {
            "token": token,
          }),
          data: {
            "uid": uid,
            "goodsId": goodsId,
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return true;
      case Status.INVALID_AUTHORIZE:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("登录信息过期")));
        await Provider.of<UserProvider>(context, listen: false)
            .cleanDataAndBackToHome(context);
        break;
      case Status.RES_NOT_ALLOW:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("金币不足")));
        break;
      case Status.RES_NOT_MATCH:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("库存不足")));
        break;
      case Status.CREATE_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("邮件发送失败")));
        break;
      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return false;
  }

  Future<bool> uploadDB(
      BuildContext context, int uid, String token, List<int> data) async {
    Response response;
    try {
      response = await _dio.put(
        "${Api.user}/$uid/data",
        options: Options(headers: {
          "token": token,
        }),
        data: {
          "data" : data
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return true;
      case Status.INVALID_AUTHORIZE:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("登录信息过期")));
        await Provider.of<UserProvider>(context, listen: false)
            .cleanDataAndBackToHome(context);
        break;
      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return false;
  }

  Future<List<int>> downloadDB(
      BuildContext context, int uid, String token) async {
    Response response;
    try {
      response = await _dio.get(
        "${Api.user}/$uid/data",
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            "token": token,
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    switch (Status.of(response)) {
      case Status.OK:
        return response.data;
      case Status.RES_NOT_FOUND:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("云端无数据")));
        await Provider.of<UserProvider>(context, listen: false)
            .cleanDataAndBackToHome(context);
        break;
      case Status.INVALID_AUTHORIZE:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("登录信息过期")));
        await Provider.of<UserProvider>(context, listen: false)
            .cleanDataAndBackToHome(context);
        break;
      case Status.CONNECT_FAIL:
        await PopMenus.attention(
            context: context, content: Text(I18N.of("连接失败")));
        break;
    }
    return null;
  }
}
