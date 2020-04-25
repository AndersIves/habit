import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/provider/ThemeProvider.dart';
import 'package:habit/common/utils/ConvertUtils.dart';
import 'package:provider/provider.dart';

class DateTimeMultiLineChart extends StatelessWidget {
  final Map<String, List<FlSpot>> lineNameSportsMap;

  final int size;

  DateTimeMultiLineChart({
    @required this.lineNameSportsMap,
    this.size,
  });

  List<LineChartBarData> getLineChartBarData(BuildContext context) {
    int i = 0;
    List<LineChartBarData> out = lineNameSportsMap.values.map((sports) {
      LineChartBarData lineChartBarData = LineChartBarData(
        spots: sports,
        // 圆滑
        isCurved: size > 7,
        // 线条颜色
        colors: [
          Provider.of<ThemeProvider>(context, listen: false).otherColors[i]
        ],
        // 线条宽度
        barWidth: 3,
        // 起点和终点是否圆滑
        isStrokeCapRound: true,
        // 点配置
        dotData: FlDotData(
          show: size < 30,
          dotColor:
              Provider.of<ThemeProvider>(context, listen: false).otherColors[i],
          dotSize: 3,
        ),
        belowBarData: BarAreaData(
          show: false,
          colors: [Theme.of(context).accentColor.withOpacity(0.1 / (i + 1))],
        ),
      );
      i = (i + 1) % (themeColors.length - 1);
      return lineChartBarData;
    }).toList();
    return out;
  }

  @override
  Widget build(BuildContext context) {
    double maxY, minY, maxX, minX, xInterval, yInterval;
    bool isEmpty = false;
    lineNameSportsMap.values.forEach((i){
      if (i.isEmpty) {
        isEmpty = true;
      }
    });
    if (!isEmpty) {
      double now =
          ConvertUtils.localDaysSinceEpoch(DateTime.now()).floorToDouble();
      maxX = now;
      minX = now - size;
      maxY = 24;
      minY = 0;
      switch (size) {
        case 7:
          xInterval = 1;
          break;
        case 30:
          xInterval = 5;
          break;
        case 90:
          xInterval = 18;
          break;
        default:
          xInterval = 1;
          break;
      }
      yInterval = 1;
    }
    int i = 0;
    return isEmpty
        ? Container(
            child: Column(
            children: <Widget>[
              Text(
                I18N.of("无数据"),
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(color: Theme.of(context).accentColor),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    I18N.of("添加数据后会展示对应图表"),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ],
          ))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: lineNameSportsMap.keys.map((s) {
                  // 右显数据
                  Widget w = Text(
                    "$s —  ",
                    style: TextStyle(
                        color:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .otherColors[i]),
                  );
                  i = (i + 1) % (themeColors.length - 1);
                  return w;
                }).toList(),
              ),
              Container(
                height: 450,
                padding: EdgeInsets.only(top: 20, left: 10, right: 20),
                child: LineChart(
                  LineChartData(
                    clipToBorder: true,
                    // 边框信息
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Theme.of(context).accentColor,
                        width: 1,
                      ),
                    ),
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.03),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      // 从左到右每隔几个整数数据画条竖线
                      verticalInterval: xInterval,
                      // 横向网格线
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).accentColor,
                          strokeWidth: 0.5,
                        );
                      },
                      horizontalInterval: yInterval,
                      // 纵向网格线
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).accentColor,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    // 点击响应信息
                    lineTouchData: LineTouchData(
                      enabled: false,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Theme.of(context)
                            .accentColor
                            .withOpacity(0.2)
                            .withAlpha(100),
                        fitInsideHorizontally: true,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      // 下方文字
                      bottomTitles: SideTitles(
                        // 每隔几个显示一个底部标签
                        interval: xInterval,
                        showTitles: true,
                        // 文字与图表上边界距离
//          margin: 8,
                        // 文字预留空间
//          reservedSize: 22,
                        textStyle: Theme.of(context).textTheme.body1,
                        getTitles: (value) {
                          DateTime dateTime =
                              ConvertUtils.dateTimeOfLocalDaysSinceEpoch(value);
                          return "${dateTime.month}-${dateTime.day}";
                        },
                      ),
                      leftTitles: SideTitles(
                        // 每隔几个显示一个左侧标签
                        interval: yInterval,
                        showTitles: true,
                        // 文字与图表左边界距离
//          margin: 8,
                        // 文字预留空间
                        reservedSize: 30,
                        textStyle: Theme.of(context).textTheme.body1,
                        getTitles: (value) {
                          int hour = 24 -  value.floor();
                          if (hour < 10) {
                            return "0$hour:00";
                          }
                          return "$hour:00";
                        },
                      ),
                    ),
                    // 各轴显示的最值 (不设置则缩放)
                    minX: minX,
                    maxX: maxX,
                    maxY: maxY,
                    minY: minY,

                    // 数据
                    lineBarsData: getLineChartBarData(context),
                  ),
                ),
              )
            ],
          );
  }
}
