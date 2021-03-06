import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/DataProvider.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:habit/database/entity/ExerciseInfo.dart';
import 'package:habit/database/entity/SportInfo.dart';
import 'package:habit/database/mapper/ExerciseInfoMapper.dart';
import 'package:habit/database/mapper/SportInfoMapper.dart';
import 'package:habit/network/Repository.dart';
import 'package:provider/provider.dart';

class ExerciseInfoRecordingPage extends StatefulWidget {
  @override
  _ExerciseInfoRecordingPageState createState() =>
      _ExerciseInfoRecordingPageState();
}

class _ExerciseInfoRecordingPageState extends State<ExerciseInfoRecordingPage> {
  List<SportInfo> spots;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spots = [];
    loadData();
  }

  Future<void> loadData() async {
    spots = await SportInfoMapper()
        .selectAll(orderBy: "sportTimes desc,name asc, hkCalorie asc");
    setState(() {});
  }

  Future<void> onSelected(SportInfo sportInfo) async {
    TextEditingController intakeController = new TextEditingController();
    List res = await PopMenus.baseMenu<List>(
      context: context,
      title: Text(sportInfo.getName()),
      children: <Widget>[
        Divider(),
        Text("${I18N.of("运动次数")}: ${sportInfo.getSportTimes()}"),
        Text("${I18N.of("消耗热量")}: ${sportInfo.getHkCalorie()} (h/kcal)"),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: intakeController,
          decoration: InputDecoration(
            icon: Icon(Icons.timer),
            labelText: "${I18N.of("运动时长")} (min)",
            hintText: I18N.of("请输入运动时长"),
          ),
        ),
        FlatButton(
          child: Text(I18N.of("确定")),
          onPressed: () async {
            if (intakeController.text.trim().isNotEmpty &&
                double.tryParse(intakeController.text.trim()) != null) {
              Navigator.of(context).pop([
                sportInfo.getId(),
                double.parse(intakeController.text.trim()) / 60,
                sportInfo.getSportTimes(),
              ]);
            } else {
              await PopMenus.attention(
                  context: context, content: Text(I18N.of("输入有误")));
            }
          },
        ),
      ],
      contentPadding: EdgeInsets.all(16),
    );
    if (res != null) {
      // 记录
      // 更新次数
      SportInfo sportInfo = new SportInfo();
      sportInfo.setId(res[0]);
      sportInfo.setSportTimes(res[2] + 1);
      await SportInfoMapper().updateByFirstKeySelective(sportInfo);
      // 记录数据
      DateTime now = DateTime.now();
      ExerciseInfo exerciseInfo = new ExerciseInfo();
      exerciseInfo.setSportId(res[0]);
      exerciseInfo.setExerciseQuantity(res[1]);
      exerciseInfo.setExerciseTime(now.millisecondsSinceEpoch);
      // 今日首次运动？
      List<ExerciseInfo> localExerciseInfo = await ExerciseInfoMapper().selectWhere(
          "exerciseTime > ${ConvertUtils.dateOfDateTime(now).millisecondsSinceEpoch}");
      if (localExerciseInfo.isEmpty){
        // 今日首次运动
        // 增加金币
        UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
        if (userProvider.token != null) {
          int increasedCoin = await Repository.getInstance()
              .increaseCoin(context, userProvider.uid, userProvider.token);
          if (increasedCoin != null) {
            await PopMenus.coinAdd(
                context: context, addedCoins: increasedCoin);
            userProvider.coins += increasedCoin;
            userProvider.refresh();
          }
        }
      }
      await ExerciseInfoMapper().insert(exerciseInfo);
      await Provider.of<DataProvider>(context,listen: false).loadExerciseInfoData();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("体育锻炼记录")),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String name = await showSearch<String>(
                context: context,
                delegate: _SportSearchDelegate(spots),
              );
              await loadData();
              List<SportInfo> list =
                  spots.where((test) => test.getName() == name).toList();
              if (list.isNotEmpty) {
                await onSelected(list.last);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.directions_run),
              title: Text(I18N.of("添加运动")),
              trailing: Icon(Icons.add),
              onTap: () async {
                TextEditingController nameController =
                    new TextEditingController();
                TextEditingController gkCalorieController =
                    new TextEditingController();
                await PopMenus.baseMenu<String>(
                  context: context,
                  title: Text(I18N.of("添加运动")),
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.fitness_center),
                        labelText: I18N.of("运动名称"),
                        hintText: I18N.of("请输入运动名称"),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: gkCalorieController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.whatshot),
                        labelText: "${I18N.of("消耗热量")} (h/kcal)",
                        hintText: I18N.of("请输入消耗热量"),
                      ),
                    ),
                    FlatButton(
                      child: Text(I18N.of("确定")),
                      onPressed: () async {
                        if (nameController.text.trim().isNotEmpty &&
                            gkCalorieController.text.trim().isNotEmpty &&
                            double.tryParse(gkCalorieController.text.trim()) !=
                                null) {
                          SportInfo sportInfo = new SportInfo();
                          sportInfo.setName(nameController.text.trim());
                          sportInfo.setHkCalorie(
                              double.parse(gkCalorieController.text.trim()));
                          sportInfo.setSportTimes(0);
                          bool isSuccess =
                              await SportInfoMapper().insert(sportInfo);
                          if (isSuccess) {
                            await loadData();
                            Navigator.of(context).pop();
                          } else {
                            await PopMenus.attention(
                                context: context,
                                content: Text(I18N.of("该运动已存在")));
                          }
                        } else {
                          await PopMenus.attention(
                              context: context, content: Text(I18N.of("输入有误")));
                        }
                      },
                    ),
                  ],
                  contentPadding: EdgeInsets.all(16),
                );
              },
            ),
            Divider(),
            Text(
              I18N.of("长按可删除运动"),
              style: Theme.of(context).textTheme.caption,
            ),
            Expanded(
              child: ListView(
                children: spots.map((i) {
                  return ListTile(
                    title: Text(i.getName()),
                    subtitle: Text(
                        "${I18N.of("消耗热量")}: ${i.getHkCalorie()} (h/kcal)"),
                    trailing: Text("${I18N.of("运动次数")}: ${i.getSportTimes()}"),
                    onTap: () {
                      onSelected(i);
                    },
                    onLongPress: () async {
                      await PopMenus.sliderConfirm(
                        context: context,
                        content: Text(I18N.of("滑动来删除该条数据")),
                        function: () async {
                          if (i.getSportTimes() == 0) {
                            await SportInfoMapper().delete(i);
                            await loadData();
                            await PopMenus.attention(
                                context: context,
                                content: Text(I18N.of("删除成功")));
                          } else {
                            await PopMenus.attention(
                                context: context,
                                content: Text(I18N.of("您不能删除记录过的运动")));
                          }
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SportSearchDelegate extends SearchDelegate<String> {
  List<SportInfo> spots;

  _SportSearchDelegate(this.spots);

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        this.close(context, null);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView(
        children:
            spots.where((test) => test.getName().contains(query)).map((i) {
          return ListTile(
            title: Text(i.getName()),
            subtitle: Text("${I18N.of("消耗热量")}: ${i.getHkCalorie()} (h/kcal)"),
            trailing: Text("${I18N.of("运动次数")}: ${i.getSportTimes()}"),
            onTap: () {
              this.close(context, i.getName());
            },
            onLongPress: () async {
              await PopMenus.sliderConfirm(
                context: context,
                content: Text(I18N.of("滑动来删除该条数据")),
                function: () async {
                  if (i.getSportTimes() == 0) {
                    await SportInfoMapper().delete(i);
                    await PopMenus.attention(
                        context: context, content: Text(I18N.of("删除成功")));
                    this.close(context, null);
                  } else {
                    await PopMenus.attention(
                        context: context,
                        content: Text(I18N.of("您不能删除记录过的运动")));
                  }
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => I18N.of("搜索");
}
