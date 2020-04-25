import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/components/UserListTile.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/network/Repository.dart';
import 'package:provider/provider.dart';

class RankingListPage extends StatefulWidget {
  @override
  _RankingListPageState createState() => _RankingListPageState();
}

class _RankingListPageState extends State<RankingListPage> {
  bool isRequesting;

  List data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRequesting = true;
    data = [];
    getData();
  }

  Future<void> getData() async {
    data = await Repository.getInstance().getCoinTop(context, 20);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.uid != null && !data.contains(userProvider.uid)) {
      data.add(userProvider.uid);
    }
    int rank = 0;
    data = data.map((i) {
      rank++;
      if (rank == 21) {
        return {
          "uid": i,
          "rank": I18N.of("未入榜"),
        };
      }
      return {
        "uid": i,
        "rank": rank,
      };
    }).toList();
    isRequesting = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("排行榜")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            isRequesting ? LinearProgressIndicator() : Container(),
            Column(
              children: data.map((i) {
                return UserListTile(
                  uid: i["uid"],
                  trailing: Text("${I18N.of("排名")}: ${i["rank"].toString()}"),
                  onPress: () async {
                    await PopMenus.userInfo(context: context, uid: i["uid"]);
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
