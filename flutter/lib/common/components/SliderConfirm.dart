import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';

class SliderConfirm extends StatefulWidget {
  final Function function;

  SliderConfirm({@required this.function});

  @override
  _SliderConfirmState createState() => _SliderConfirmState();
}

class _SliderConfirmState extends State<SliderConfirm> {
  double currentValue;
  bool isEnd;
  bool isFormStart;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentValue = 0;
    isEnd = false;
    isFormStart = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Slider(
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Colors.transparent,
              value: currentValue,
              min: 0,
              max: 1,
              onChanged: (value) {
                if (value <= 0.1) {
                  currentValue = value;
                  isFormStart = true;
                  setState(() {});
                }
                if (isFormStart) {
                  currentValue = value;
                  isEnd = currentValue == 1;
                  setState(() {});
                }
              },
              onChangeEnd: (value) {
                if (isEnd) {
                  widget.function();
                } else {
                  isFormStart = false;
                  currentValue = 0;
                  setState(() {});
                }
              },
            ),
          ),
        ),
        Center(
          child: isEnd
              ? Text(
                  I18N.of("松开以继续"),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(color: Theme.of(context).accentColor),
                )
              : Text(
                  I18N.of("向右滑动"),
                  style: Theme.of(context).textTheme.subtitle,
                ),
        ),
      ],
    );
  }
}
