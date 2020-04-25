import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/components/PopMenus.dart';
import 'package:habit/common/provider/UserProvider.dart';
import 'package:habit/network/Repository.dart';
import 'package:provider/provider.dart';

class GoodsPage extends StatefulWidget {
  final dynamic data;

  GoodsPage(this.data);

  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  bool isRequesting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRequesting = false;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("商品详情")),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            isRequesting ? LinearProgressIndicator() : Container(),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).unselectedWidgetColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: <Widget>[
                    Markdown(
                      data: widget.data["description"],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.zoom_out_map,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Scaffold(
                                        appBar: AppBar(
                                          title: Text(
                                              widget.data["name"].toString()),
                                        ),
                                        body: Markdown(
                                          data: widget.data["description"]
                                              .toString(),
                                        ),
                                      ))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${widget.data["price"].toString()} ",
                  style: TextStyle(fontSize: 34),
                ),
                Icon(
                  Icons.monetization_on,
                  size: 30,
                ),
              ],
            ),
            Text(
              "[${I18N.of("官方合作")}] ${widget.data["name"].toString()}",
              maxLines: 2,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "${I18N.of("库存")} : ${widget.data["count"].toString()}",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                Column(
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Theme.of(context).cardColor,
                      child: Text(userProvider.token == null ? I18N.of("请先登录") : I18N.of("立即获取优惠口令")),
                      onPressed: userProvider.token == null || isRequesting
                          ? null
                          : () async {
                              UserProvider userProvider =
                                  Provider.of<UserProvider>(context,
                                      listen: false);
                              isRequesting = true;
                              setState(() {});
                              bool isSuccess = await Repository.getInstance()
                                  .buyGoods(context, userProvider.token,
                                      userProvider.uid, widget.data["goodsId"]);
                              if (isSuccess) {
                                userProvider.coins =
                                    await Repository.getInstance()
                                        .getCoin(userProvider.uid);
                                userProvider.refresh();
                                await PopMenus.attention(
                                    context: context,
                                    content:
                                        Text(I18N.of("感谢您的支持，优惠口令已发送至您的邮箱")));
                              }
                              isRequesting = false;
                              setState(() {});
                            },
                    ),
                    Text(
                      I18N.of("重复购买不会重复扣费"),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
