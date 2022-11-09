
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:we_budget/components/sector.dart';

class PieChartWidget extends StatelessWidget {
  final List<Sector> sectors;

  const PieChartWidget(this.sectors, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.5,
        child: PieChart(PieChartData(
          sections: _chartSections(sectors),
          centerSpaceRadius: 80.0,
        )));
  }

  List<PieChartSectionData> _chartSections(List<Sector> sectors) {
    final List<PieChartSectionData> list = [];
    double soma_total = 0.0;
    int qtd =  0;
    for (var sector in sectors){
      soma_total += sector.value;
      qtd++;
    }
    for (var sector in sectors) {
      print(sector.value);
      const double radius = 40.0;
      final data = PieChartSectionData(
        color: sector.color,
        value: sector.value,
        radius: radius,
        title: ((sector.value/soma_total)*100).toStringAsPrecision(2) + '%',
      );
      list.add(data);
    }
    return list;
  }
}