import 'dart:math';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:we_budget/components/categoria_dropdown.dart';

import 'package:we_budget/components/price_point.dart';
import '../models/transactions.dart';

class LineChartWidget extends StatefulWidget {
  // final List<PricePoint> points;
  final List<TransactionModel> transactions;

  const LineChartWidget(this.transactions, {Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _LineChartWidgetState();

}

class _LineChartWidgetState extends State<LineChartWidget>{
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
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
              spots: _pricePoints(widget.transactions).map((point) => FlSpot(point.x, point.y)).toList(),
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
}
class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint>  _pricePoints(List<TransactionModel> transactions) {
  int qtd_total = transactions.length;
  int qtd_periodo = 5;
  List<double> valores = List.filled(qtd_periodo, 0);
  List<String> anos = ['2018','2019','2018','2021','2022'];
  int index = 0;
    anos.forEach((ano) {
      transactions.forEach((element) {
        String dataFormatada = element.data.substring(0,4);
        if(dataFormatada==ano){
          if(element.tipoTransacao==0){
            valores[index]+=element.valor;
          }
        }
      });
      index++;
    });
  print('valores:');
  print(valores);

  print(valores
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList().map((point) => FlSpot(point.x, point.y)).toList());
  // for (var i = 0; i <= 11; i++) {
  //   randomNumbers.add(random.nextInt(5000).toDouble());
  // }

  // List<PricePoint> points = [];
  // double i = 0;
  // valores.forEach((element) {
  //   points.add(PricePoint(x: element, y: i));
  // });

  return valores
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();
}


SideTitles get _bottomTitles => SideTitles(
  showTitles: true,
  getTitlesWidget: (value, meta) {
    String text = '';
    switch (value.toInt()) {
      case 0:
        text = '2018';
        break;
      case 1:
        text = '2019';
        break;
      case 2:
        text = '2020';
        break;
      case 3:
        text = '2021';
        break;
      case 4:
        text = '2022';
        break;

    }

    return Text(text);
  },
);