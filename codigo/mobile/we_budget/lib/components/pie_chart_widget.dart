import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/components/sector.dart';

import '../models/transactions.dart';

class PieChartWidget extends StatefulWidget {
  final List<TransactionModel> listTransacion;
  final List<Sector> sectors = [];
  //Lista de transações que chegou por parâmetros
  //Preciso de alimentar a lista de sectors.
  //De para-----------para cada item da lista, eu crio um Sector.

  // const
  PieChartWidget(this.listTransacion, {Key? key}) : super(key: key);

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
          sections: _chartSections(widget.sectors),
          centerSpaceRadius: 80.0,
        ),
      ),
    );
  }

  List<PieChartSectionData> _chartSections(List<Sector> sectors) {
    final List<PieChartSectionData> list = [];
    double soma_total = 0.0;
    int qtd = 0;
    for (var sector in sectors) {
      soma_total += sector.value;
      qtd++;
    }
    for (var sector in sectors) {
      const double radius = 40.0;
      final data = PieChartSectionData(
        color: sector.color,
        value: sector.value,
        radius: radius,
        title: ((sector.value / soma_total) * 100).toStringAsPrecision(2) + '%',
      );
      list.add(data);
    }
    return list;
  }
}
