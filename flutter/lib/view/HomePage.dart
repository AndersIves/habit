import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/view/context/ExerciseInfoContext.dart';
import 'package:habit/view/context/LifeInfoContext.dart';
import 'package:habit/view/context/BasicInfoContext.dart';
import 'package:habit/view/context/StudyInfoContext.dart';
import 'package:habit/view/drawer/HomePageDrawer.dart';
import 'package:habit/view/record/BasicInfoRecordingPage.dart';
import 'package:habit/view/record/ExerciseInfoRecordingPage.dart';
import 'package:habit/view/record/LifeInfoRecordingPage.dart';
import 'package:habit/view/record/StudyInfoRecordingPage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomePageService>(
            create: (_) => HomePageService(context)),
        ChangeNotifierProvider<HomePageModel>(
            create: (_) => HomePageModel(context)),
      ],
      child: _HomePageView(),
    );
  }
}

// model
class HomePageModel extends BaseModel {
  HomePageModel(BuildContext context) : super(context);

  int currentIndex;

  PageController pageViewController;

  @override
  void init(BuildContext context) {
    // TODO: implement init
    super.init(context);
    currentIndex = 0;
    pageViewController = new PageController(initialPage: 0);
  }
}

// service
class HomePageService extends BaseService {
  HomePageService(BuildContext context) : super(context);

  void changeNavigation(BuildContext context, int index) {
    HomePageModel model = Provider.of<HomePageModel>(context, listen: false);
    model.currentIndex = index;
    model.pageViewController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
    model.refresh();
  }


  void onPageChanged(BuildContext context, int index) {
    HomePageModel model = Provider.of<HomePageModel>(context, listen: false);
    model.currentIndex = index;
    model.refresh();
  }

  Future<void> toBasicInfoRecordingPage(BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => BasicInfoRecordingPage()));
  }

  Future<void> toLifeInfoRecordingPage(BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => LifeInfoRecordingPage()));
  }

  Future<void> toExerciseInfoRecordingPage(BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ExerciseInfoRecordingPage()));
  }

  Future<void> toStudyInfoRecordingPage(BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => StudyInfoRecordingPage()));
  }
}

// view
class _HomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomePageService service =
        Provider.of<HomePageService>(context, listen: false);
    HomePageModel model = Provider.of<HomePageModel>(context, listen: true);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of(<String>[
          "基本信息",
          "日常生活",
          "体育锻炼",
          "课程学习",
        ][model.currentIndex])),
        actions: userProvider.token == null
            ? []
            : <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "${userProvider.coins} x ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.monetization_on),
                    Text("  "),
                  ],
                ),
              ],
      ),
      drawer: HomePageDrawer(),
      body: PageView(
        controller: model.pageViewController,
        onPageChanged: (index) => service.onPageChanged(context, index),
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          BasicInfoContext(),
          LifeInfoContext(),
          ExerciseInfoContext(),
          StudyInfoContext(),
        ],
      ),
      floatingActionButton: <Widget>[
        FloatingActionButton(
          child: Icon(Icons.playlist_add),
          onPressed: () => service.toBasicInfoRecordingPage(context),
        ),
        FloatingActionButton(
          child: Icon(Icons.playlist_add),
          onPressed: () => service.toLifeInfoRecordingPage(context),
        ),
        FloatingActionButton(
          child: Icon(Icons.playlist_add),
          onPressed: () => service.toExerciseInfoRecordingPage(context),
        ),
        FloatingActionButton(
          child: Icon(Icons.playlist_add),
          onPressed: () => service.toStudyInfoRecordingPage(context),
        ),
      ][model.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: model.currentIndex,
        onTap: (index) => service.changeNavigation(context, index),
        showUnselectedLabels: true,
        fixedColor: Theme.of(context).accentColor,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility), title: Text(I18N.of("基本信息"))),
          BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny), title: Text(I18N.of("日常生活"))),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_bike), title: Text(I18N.of("体育锻炼"))),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text(I18N.of("课程学习"))),
        ],
      ),
    );
  }
}
