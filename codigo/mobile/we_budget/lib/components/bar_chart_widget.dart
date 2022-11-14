
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:we_budget/components/categoria_dropdown.dart';

import 'package:we_budget/components/price_point.dart';
import '../models/transactions.dart';

import 'package:we_budget/components/price_point.dart';
import 'package:we_budget/models/transactions.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key, required this.transactions}) : super(key: key);

  final List<TransactionModel> transactions;

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: BarChart(
        BarChartData(
          barGroups: _chartGroups(widget.transactions),
          borderData: FlBorderData(
              border: const Border(bottom: BorderSide(), left: BorderSide())),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _chartGroups(List<TransactionModel> transactiones) {
    int qtd_total = transactiones.length;
    int qtd_periodo = 5;
    List<double> valores = List.filled(qtd_periodo, 0);
    List<String> anos = ['2018','2019','2018','2021','2022'];
    int index = 0;
    anos.forEach((ano) {
      transactiones.forEach((element) {
        String dataFormatada = element.data.substring(0,4);
        if(dataFormatada==ano){
          if(element.tipoTransacao==1){
            valores[index]+=element.valor;
          }
        }
      });
      index++;
    });
    print('valores:');
    print(valores);

    List<PricePoint> points = [];
    double i = 0;
    valores.forEach((element) {
      if(element < 1)element = 0.00001;
      points.add(PricePoint(x: i, y: element));
      i++;
    });
    return points.map((point) =>
        BarChartGroupData(
            x: point.x.toInt(),
            barRods: [
              BarChartRodData(
                  toY: point.y
              )
            ]
        )

    ).toList();
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
}
class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}