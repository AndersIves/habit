import 'package:flutter/material.dart';
import 'package:habit/common/BaseArchitectural.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/ThemeProvider.dart';
import 'package:provider/provider.dart';

class ThemeSetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeSetPageService>(
            create: (_) => ThemeSetPageService(context)),
      ],
      child: _ThemeSetPageView(),
    );
  }
}
// service
class ThemeSetPageService extends BaseService {
  ThemeSetPageService(BuildContext context) : super(context);


  bool isCurrent(BuildContext context, int index) {
    return Provider.of<ThemeProvider>(context, listen: false).currentIndex == index;
  }

  void changeThemeTo(BuildContext context, int index) {
    Provider.of<ThemeProvider>(context, listen: false).changeTheme(index);
    Navigator.of(context).pop();
  }
}

// view
class _ThemeSetPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeSetPageService service =
    Provider.of<ThemeSetPageService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(I18N.of("主题")),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index < themeColors.length) {
              return ListTile(
                leading: service.isCurrent(context, index)
                    ? Icon(
                  Icons.radio_button_checked,
                  color: Theme.of(context).primaryColor,
                )
                    : Icon(Icons.radio_button_unchecked),
                title: RaisedButton(
                  color: themeColors[index],
                  onPressed: () => service.changeThemeTo(context, index),
                ),
              );
            } else if (index == themeColors.length) {
              return ListTile(
                leading: service.isCurrent(context, index)
                    ? Icon(
                  Icons.radio_button_checked,
                  color: Theme.of(context).primaryColor,
                )
                    : Icon(Icons.radio_button_unchecked),
                title: RaisedButton(
                  color: Colors.black,
                  onPressed: () => service.changeThemeTo(context, index),
                ),
              );
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }
}