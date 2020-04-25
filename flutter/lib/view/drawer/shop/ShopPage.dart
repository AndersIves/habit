import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/network/Repository.dart';
import 'package:habit/view/drawer/shop/GoodsPage.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool isRequesting;

  List data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRequesting = true;
    data = [];
    loadData();
  }

  Future<void> loadData() async {
    data = await Repository.getInstance().getGoodsList(context);
    isRequesting = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("商城")),
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            isRequesting ? LinearProgressIndicator() : Container(),
            Column(
              children: data.map((i) {
                return ListTile(
                  leading: Icon(Icons.shopping_basket),
                  title: Text(
                    i["name"].toString(),
                    maxLines: 1,
                  ),
                  subtitle: Text("${I18N.of("金币")} : ${i["price"].toString()}"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => GoodsPage(i)));
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
