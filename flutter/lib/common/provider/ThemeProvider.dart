import 'package:flutter/material.dart';

import '../LocalData.dart';

class ThemeProvider extends ChangeNotifier {
  int currentIndex;

  MaterialColor currentMaterialColor;

  Brightness currentBrightness;

  List<Color> otherColors;

  ThemeProvider() {
    currentIndex = 0;
    currentMaterialColor = Colors.amber;
    currentBrightness = Brightness.light;
    otherColors = [];
  }

  void init() {
    int index = LocalData.getInstance().getInt("theme");
    if (index == null) {
      index = 0;
      LocalData.getInstance().setInt("theme", index);
    }
    changeTheme(index);
    debugPrint(
        "init ThemeProvider to: $currentMaterialColor, $currentBrightness");
  }

  void changeTheme(int index) {
    if (index == themeColors.length) {
      currentMaterialColor = Colors.teal;
      currentBrightness = Brightness.dark;
    } else {
      currentMaterialColor = themeColors[index];
      currentBrightness = Brightness.light;
    }
    currentIndex = index;
    LocalData.getInstance().setInt("theme", index);
    otherColors = List<Color>.of(themeColors);
    otherColors.remove(currentMaterialColor);
    notifyListeners();
  }
}



List<MaterialColor> themeColors = [
  Colors.amber,
  Colors.pink,
  Colors.green,
  Colors.purple,
  Colors.blue,
  Colors.cyan,
  Colors.brown,
];
