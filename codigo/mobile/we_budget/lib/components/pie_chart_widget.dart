import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/components/categoria_dropdown.dart';

import '../models/transactions.dart';
import 'menu_component.dart';

class PieChartWidget extends StatefulWidget {
  final List<TransactionModel> listTransacion;
  final List<Sector> sectors = [];
  final List<MaterialAccentColor> colors = [
    Colors.greenAccent,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.tealAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.yellowAccent,
    Colors.orangeAccent,
    Colors.lightGreenAccent,
    Colors.cyanAccent,
    Colors.deepOrangeAccent,
    Colors.indigoAccent,
    Colors.amberAccent,
    Colors.limeAccent,
  ];
  //Lista de transações que chegou por parâmetros
  //Preciso de alimentar a lista de sectors.
  //De para-----------para cada item da lista, eu crio um Sector.

  // const
  PieChartWidget(this.listTransacion, {Key? key}) : super(key: key);

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}
class Sector {
  final Color color;
  final double value;
  final String title;

  Sector({required this.color, required this.value, required this.title});
}

class _PieChartWidgetState extends State<PieChartWidget> {
  List<Sector> get industrySectors {
    return
      widget.sectors;
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: PieChart(
            PieChartData(

              sections: _chartSections(widget.sectors,widget.listTransacion),
              centerSpaceRadius: 80.0,
            ),
          ),
        ),
        Column(
          children: industrySectors
          .map<Widget>((sector) => SectorRow(sector))
          .toList(),
        ),
      ],
    );
    // Column(
    //   children: widget.listTransacion
    //       .map<Widget>((sector) => SectorRow(sector))
    //       .toList(),
    // ),

  }

  List<PieChartSectionData> _chartSections(List<Sector> sectors, List<TransactionModel> listTransacion) {
    List<String> categories = [];
    print(listTransacion.toString());
    listTransacion.forEach((transact) {
      bool existe = false;
      categories.forEach((categoria) {
        if(transact.categoria.toString() == categoria){
          existe = true;
        }
      });
      if(!existe){
        if(transact.tipoTransacao == 1) {
          categories.add(transact.categoria.toString());
        }
      }
    });
    List<double> numbers = List.filled(categories.length, 0);
    int index = 0;
    categories.forEach((categoria) {
      listTransacion.forEach((transact) {
        if(transact.tipoTransacao == 1) {
          if(transact.categoria.toString() == categoria) {
            numbers[index] += transact.valor;
         }
        }
      });
      index++;
    });
    int index2 = 0;
    numbers.forEach((element) {
      sectors.add(
          Sector(color: widget.colors.elementAt(index2), value: numbers[index2], title: categories.elementAt(index2))
      );
      index2++;
    });
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
    print('fim');
    print(categories);
    print(numbers);
    return list;
  }
}

