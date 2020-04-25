import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/LocalData.dart';
import 'package:habit/common/SqfliteDataBase.dart';
import 'package:habit/common/provider/ConfigProvider.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/NotificationProvider.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/provider/ThemeProvider.dart';
import 'package:habit/view/HomePage.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoadingPageService>(
            create: (_) => LoadingPageService(context)),
      ],
      child: _LoadingPageView(),
    );
  }
}

// service
class LoadingPageService extends BaseService {
  LoadingPageService(BuildContext context) : super(context);

  Timer timer;

  bool isLoaded;

  Future<void> loadData(BuildContext context) async {
    // ================================== init ==================================
    await LocalData.init();

//    LocalData.getInstance().clear();

    I18N.init();
    Provider.of<ThemeProvider>(context, listen: false).init();
    Provider.of<UserProvider>(context, listen: false).init();
    Provider.of<ConfigProvider>(context, listen: false).init();
    await Provider.of<NotificationProvider>(context, listen: false).init();
    await SqfliteDataBase.init();
//    await SqfliteDataBase.resetTables();
    await Provider.of<DataProvider>(context, listen: false).init();
    isLoaded = true;
    // ================================== over ==================================
  }

  @override
  void init(BuildContext context) {
    // TODO: implement init
    super.init(context);
    isLoaded = false;
    timer = null;
    startCountDown(context);
    loadData(context);
  }

  void startCountDown(BuildContext context) {
    if (timer == null) {
      int minDuration = 3;
      timer = Timer.periodic(Duration(seconds: 1), (t) {
        minDuration--;
        if (isLoaded && minDuration <= 0) {
          timer.cancel();
          scalaJumpToHomePage(context);
        }
      });
    }
  }

  void scalaJumpToHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
//          FadeTransition(opacity: animation, child: HomePage())));
            ScaleTransition(scale: animation, child: HomePage())));
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

class _LoadingPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoadingPageService service =
        Provider.of<LoadingPageService>(context, listen: false);
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Image.asset(
        "res/welcome.png",
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
