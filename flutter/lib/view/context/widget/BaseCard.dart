import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget child;

  BaseCard({this.title, this.subtitle, this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  title ?? Container(),
                  subtitle ?? Container(),
                ],
              ),
              Divider(),
              child ?? Container(),
            ],
          ),
        ));
  }
}
