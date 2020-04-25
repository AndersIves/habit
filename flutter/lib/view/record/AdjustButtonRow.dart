import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';

class SlideAdjuster extends StatefulWidget {
  final String titleString;
  final double startValue;
  final Function(double value) onValueChange;

  SlideAdjuster(
      {this.titleString,
      @required this.startValue,
      @required this.onValueChange});

  @override
  _SlideAdjusterState createState() {
    // TODO: implement createState
    return _SlideAdjusterState();
  }
}

class _SlideAdjusterState extends State<SlideAdjuster> {
  int value;

  double rollValue = 0;

  bool onHandel = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value = (widget.startValue * 100).floor();
  }

  int getAddedValue() {
    if (rollValue > 0) {
      return (0.01 * rollValue * rollValue).floor();
    } else {
      return -(0.01 * rollValue * rollValue).floor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: IconButton(
            icon: Icon(Icons.restore),
            color: Theme.of(context).accentColor,
            onPressed: () {
              value = (widget.startValue * 100).floor();
              widget.onValueChange(value / 100);
              setState(() {});
            },
          ),
          title: Text(widget.titleString ?? I18N.of("调整数据")),
          trailing: Text("${(value + getAddedValue()) / 100}"),
        ),
        Slider(
          min: -150,
          max: 150,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).colorScheme.primary,
          label: "${rollValue > 0 ? "+" : "-"} ${getAddedValue().abs() / 100}",
          value: rollValue,
          divisions: 200,
          onChangeStart: (v) {},
          onChanged: (v) {
            rollValue = v;
            setState(() {});
          },
          onChangeEnd: (v) {
            value = value + getAddedValue();
            widget.onValueChange(value / 100);
            rollValue = 0;
            setState(() {});
          },
        ),
      ],
    );
  }
}
