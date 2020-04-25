import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:provider/provider.dart';

class LanguageSetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("语言")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.grade,
                color: "cn" == I18N.getLanguage()
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              title: Text("中文"),
              onTap: () {
                I18N.setLanguage("cn");
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.grade,
                color: "en" == I18N.getLanguage()
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              title: Text("English"),
              onTap: () {
                I18N.setLanguage("en");
                Navigator.of(context).pop();
              },),
          ],
        ),
      ),
    );
  }
}