
import 'package:flutter/material.dart';
import 'package:habit/view/LoadingPage.dart';
import 'package:provider/provider.dart';

import 'common/provider/ThemeProvider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Provider.of<ThemeProvider>(context).currentMaterialColor,
        brightness: Provider.of<ThemeProvider>(context).currentBrightness,
      ),
//      home: LoadingPage(),
      home: LoadingPage(),
    );
  }
}