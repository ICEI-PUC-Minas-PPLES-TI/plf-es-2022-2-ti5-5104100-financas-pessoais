
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:we_budget/components/price_point.dart';

class LineChartWidget extends StatelessWidget {
  final List<PricePoint> points;

  const LineChartWidget(this.points, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.9,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            topTitles: AxisTitles(sideTitles: null),
            rightTitles: AxisTitles(sideTitles: null),
          ),
          lineBarsData: [
            LineChartBarData(
              color: Colors.green,
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: false,
              // dotData: FlDotData(
              //   show: false,
              // ),
            ),
          ],
        ),
      ),
    );

  }
  SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
      String text = '';
      switch (value.toInt()) {
        case 0:
          text = 'Jan';
          break;
        case 1:
          text = 'fev';
          break;
        case 2:
          text = 'Mar';
          break;
        case 3:
          text = 'Abr';
          break;
        case 4:
          text = 'Mai';
          break;
        case 5:
          text = 'Jun';
          break;
        case 6:
          text = 'Jul';
          break;
        case 7:
          text = 'Ago';
          break;
        case 8:
          text = 'Set';
          break;
        case 9:
          text = 'Out';
          break;
        case 10:
          text = 'Nov';
          break;
        case 11:
          text = 'Dez';
          break;
      }

      return Text(text);
    },
  );
}