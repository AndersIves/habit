import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habit/common/I18N.dart';
import 'package:habit/common/utils/ConvertUtils.dart';

class DateValueSingleLineChart extends StatelessWidget {
  final List<FlSpot> sports;

  final int size;

  final bool isEndYesterday;

  DateValueSingleLineChart({
    @required this.sports,
    this.size,
    this.isEndYesterday = false,
  });

  @override
  Widget build(BuildContext context) {
    double maxY, minY, maxX, minX, xInterval, yInterval;
    if (sports.isNotEmpty) {
      double now = ConvertUtils.localDaysSinceEpoch(isEndYesterday
              ? DateTime.now().subtract(Duration(days: 1))
              : DateTime.now())
          .floorToDouble();
      maxX = now;
      minX = now - size;
      maxY = sports[0].y;
      minY = sports[0].y;
      sports.forEach((i) {
        if (i.y < minY) {
          minY = i.y;
        }
        if (i.y > maxY) {
          maxY = i.y;
        }
      });
      if (maxY == minY) {
        maxY = maxY + 10;
        minY = minY - 10;
      } else {
        double height = maxY - minY;
        maxY = maxY + height;
        minY = minY - height;
        if (minY < 0) {
          maxY = maxY + minY;
          minY = 0;
        }
      }
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
      yInterval = ((maxY - minY) / 6);
    }
    return sports.isEmpty
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
              Container(
                height: 250,
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
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: false,
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
                        margin: 8,
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
                        reservedSize: ConvertUtils.fixedDouble(maxY, 1).toString().length * 6.5,
//                        rotateAngle: -20,
                        textStyle: Theme.of(context).textTheme.body1,
                        getTitles: (value) {
                          return ConvertUtils.fixedDouble(value, 1).toString();
                        },
                      ),
                    ),
                    // 各轴显示的最值 (不设置则缩放)
                    minX: minX,
                    maxX: maxX,
                    maxY: maxY,
                    minY: minY,

                    // 数据
                    lineBarsData: [
                      LineChartBarData(
                        spots: sports,
                        // 圆滑
                        isCurved: size > 7,
                        // 线条颜色
                        colors: [Theme.of(context).accentColor],
                        // 线条宽度
                        barWidth: 3,
                        // 起点和终点是否圆滑
                        isStrokeCapRound: true,
                        // 点配置
                        dotData: FlDotData(
                          show: size < 30,
                          dotColor: Theme.of(context).accentColor,
                          dotSize: 3,
                        ),
                        // 线下方填充
                        belowBarData: BarAreaData(
                          show: true,
                          colors: [
                            Theme.of(context).accentColor.withOpacity(0.3)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
