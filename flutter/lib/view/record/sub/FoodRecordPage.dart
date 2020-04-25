import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/database/entity/FoodInfo.dart';
import 'package:habit/database/entity/LifeInfo.dart';
import 'package:habit/database/mapper/FoodInfoMapper.dart';

class FoodRecordPage extends StatefulWidget {
  @override
  _FoodRecordPageState createState() => _FoodRecordPageState();
}

class _FoodRecordPageState extends State<FoodRecordPage> {
  List<FoodInfo> foods;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foods = [];
    loadData();
  }

  Future<void> loadData() async {
    foods = await FoodInfoMapper()
        .selectAll(orderBy: "eatTimes desc,name asc, gkCalorie asc");
    setState(() {});
  }

  Future<void> onSelected(FoodInfo foodInfo) async {
    TextEditingController intakeController = new TextEditingController();
    TextEditingController moneyController = new TextEditingController();
    List res = await PopMenus.baseMenu<List>(
      context: context,
      title: Text(foodInfo.getName()),
      children: <Widget>[
        Divider(),
        Text("${I18N.of("食用次数")}: ${foodInfo.getEatTimes()}"),
        Text("${I18N.of("食物热量")}: ${foodInfo.getHgkCalorie()} (100g/kcal)"),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: intakeController,
          decoration: InputDecoration(
            icon: Icon(Icons.restaurant),
            labelText: "${I18N.of("进食量")} (g)",
            hintText: I18N.of("请输入进食量"),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: moneyController,
          decoration: InputDecoration(
            icon: Icon(Icons.monetization_on),
            labelText: "${I18N.of("花费")}",
            hintText: I18N.of("请输入花费"),
          ),
        ),
        FlatButton(
          child: Text(I18N.of("确定")),
          onPressed: () async {
            if (intakeController.text.trim().isNotEmpty &&
                double.tryParse(intakeController.text.trim()) != null &&
                double.tryParse(moneyController.text.trim()) != null) {
              Navigator.of(context).pop([
                foodInfo.getId(),
                double.parse(intakeController.text.trim()) / 100,
                foodInfo.getEatTimes(),
                double.parse(moneyController.text.trim()),
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
      Navigator.of(context).pop(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("选择食物")),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String name = await showSearch<String>(
                context: context,
                delegate: _FoodSearchDelegate(foods),
              );
              await loadData();
              List<FoodInfo> list =
                  foods.where((test) => test.getName() == name).toList();
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
              leading: Icon(Icons.restaurant),
              title: Text(I18N.of("添加食物")),
              trailing: Icon(Icons.add),
              onTap: () async {
                TextEditingController nameController =
                    new TextEditingController();
                TextEditingController gkCalorieController =
                    new TextEditingController();
                await PopMenus.baseMenu<String>(
                  context: context,
                  title: Text(I18N.of("添加食物")),
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.restaurant_menu),
                        labelText: I18N.of("食物名称"),
                        hintText: I18N.of("请输入食物名称"),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: gkCalorieController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.whatshot),
                        labelText: "${I18N.of("食物热量")} (100g/kcal)",
                        hintText: I18N.of("请输入食物热量"),
                      ),
                    ),
                    FlatButton(
                      child: Text(I18N.of("确定")),
                      onPressed: () async {
                        if (nameController.text.trim().isNotEmpty &&
                            gkCalorieController.text.trim().isNotEmpty &&
                            double.tryParse(gkCalorieController.text.trim()) !=
                                null) {
                          FoodInfo foodInfo = new FoodInfo();
                          foodInfo.setName(nameController.text.trim());
                          foodInfo.setHgkCalorie(
                              double.parse(gkCalorieController.text.trim()));
                          foodInfo.setEatTimes(0);
                          bool isSuccess =
                              await FoodInfoMapper().insert(foodInfo);
                          if (isSuccess) {
                            await loadData();
                            Navigator.of(context).pop();
                          } else {
                            await PopMenus.attention(
                                context: context,
                                content: Text(I18N.of("该食物已存在")));
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
              I18N.of("长按可删除食物"),
              style: Theme.of(context).textTheme.caption,
            ),
            Expanded(
              child: ListView(
                children: foods.map((i) {
                  return ListTile(
                    title: Text(i.getName()),
                    subtitle: Text(
                        "${I18N.of("食物热量")}: ${i.getHgkCalorie()} (100g/kcal)"),
                    trailing: Text("${I18N.of("食用次数")}: ${i.getEatTimes()}"),
                    onTap: () {
                      onSelected(i);
                    },
                    onLongPress: () async {
                      await PopMenus.sliderConfirm(
                        context: context,
                        content: Text(I18N.of("滑动来删除该条数据")),
                        function: () async {
                          if (i.getEatTimes() == 0) {
                            await FoodInfoMapper().delete(i);
                            await loadData();
                            await PopMenus.attention(
                                context: context,
                                content: Text(I18N.of("删除成功")));
                          } else {
                            await PopMenus.attention(
                                context: context,
                                content: Text(I18N.of("您不能删除吃过的食物")));
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

class _FoodSearchDelegate extends SearchDelegate<String> {
  List<FoodInfo> foods;

  _FoodSearchDelegate(this.foods);

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
            foods.where((test) => test.getName().contains(query)).map((i) {
          return ListTile(
            title: Text(i.getName()),
            subtitle:
                Text("${I18N.of("食物热量")}: ${i.getHgkCalorie()} (100g/kcal)"),
            trailing: Text("${I18N.of("食用次数")}: ${i.getEatTimes()}"),
            onTap: () {
              this.close(context, i.getName());
            },
            onLongPress: () async {
              await PopMenus.sliderConfirm(
                context: context,
                content: Text(I18N.of("滑动来删除该条数据")),
                function: () async {
                  if (i.getEatTimes() == 0) {
                    await FoodInfoMapper().delete(i);
                    await PopMenus.attention(
                        context: context, content: Text(I18N.of("删除成功")));
                    this.close(context, null);
                  } else {
                    await PopMenus.attention(
                        context: context, content: Text(I18N.of("您不能删除吃过的食物")));
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
