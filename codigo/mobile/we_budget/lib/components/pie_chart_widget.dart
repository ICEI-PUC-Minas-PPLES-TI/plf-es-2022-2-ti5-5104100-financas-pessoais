import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/transactions.dart';
import 'menu_component.dart';

class PieChartWidget extends StatefulWidget {
  final List<TransactionModel> listTransacion;
  final String periodo;
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
  PieChartWidget(
      {Key? key, required this.periodo, required this.listTransacion})
      : super(key: key);

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
    return widget.sectors;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: PieChart(
            PieChartData(
              sections: _chartSections(
                  widget.sectors, widget.listTransacion, widget.periodo),
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

  List<PieChartSectionData>? _chartSections(List<Sector> sectors,
      List<TransactionModel> listTransacion, String periodo) {
    List<String> categories = [];
    DateTime hoje = DateTime.now();
    final List<PieChartSectionData> list = [];
    switch (periodo) {
      case 'Máx':
        listTransacion.forEach((transact) {
          bool existe = false;
          categories.forEach((categoria) {
            if (transact.categoria.toString() == categoria) {
              existe = true;
            }
          });
          if (!existe) {
            if (transact.tipoTransacao == 1) {
              categories.add(transact.categoria.toString());
            }
          }
        });
        List<double> numbers = List.filled(categories.length, 0);
        int index = 0;
        categories.forEach((categoria) {
          listTransacion.forEach((transact) {
            if (transact.categoria.toString() == categoria &&
                transact.tipoTransacao == 1) {
              numbers[index] += transact.valor;
            }
          });
          index++;
        });
        int index2 = 0;
        numbers.forEach((element) {
          sectors.add(Sector(
              color: widget.colors.elementAt(index2),
              value: numbers[index2],
              title: categories.elementAt(index2)));
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
            title: (((sector.value / soma_total) * 100)
                        .toStringAsPrecision(2) ==
                    '1.0e+2')
                ? '100%'
                : '${((sector.value / soma_total) * 100).toStringAsPrecision(2)}%',
          );
          list.add(data);
        }
        if (list.isEmpty) {
          final data = PieChartSectionData(
            color: Colors.grey,
            value: 100.0,
            radius: 40.0,
            title: ('100%'),
          );
          list.add(data);
          sectors.add(Sector(color: Colors.grey, value: 0.0, title: ('N/A')));
        }
        return list;
        break;
      case '1M':
        listTransacion.forEach((transact) {
          bool existe = false;
          categories.forEach((categoria) {
            if (transact.categoria.toString() == categoria) {
              existe = true;
            }
          });
          if (!existe) {
            List<String> campos = transact.data.split('-');
            int ano = int.parse(campos[0]);
            int mes = int.parse(campos[1]);
            int dia = int.parse(campos[2]);
            DateTime data_transact = DateTime(ano, mes, dia);
            if (transact.tipoTransacao == 1 &&
                (hoje.difference(data_transact).inDays <= 31)) {
              categories.add(transact.categoria.toString());
            }
          }
        });
        List<double> numbers = List.filled(categories.length, 0);
        int index = 0;
        categories.forEach((categoria) {
          listTransacion.forEach((transact) {
            List<String> campos = transact.data.split('-');
            int ano = int.parse(campos[0]);
            int mes = int.parse(campos[1]);
            int dia = int.parse(campos[2]);
            DateTime data_transact = DateTime(ano, mes, dia);
            if (transact.tipoTransacao == 1) {
              if (transact.categoria.toString() == categoria &&
                  (hoje.difference(data_transact).inDays <= 31)) {
                numbers[index] += transact.valor;
              }
            }
          });
          index++;
        });
        int index2 = 0;
        numbers.forEach((element) {
          sectors.add(Sector(
              color: widget.colors.elementAt(index2),
              value: numbers[index2],
              title: categories.elementAt(index2)));
          index2++;
        });
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
            title: (((sector.value / soma_total) * 100)
                        .toStringAsPrecision(2) ==
                    '1.0e+2')
                ? '100%'
                : '${((sector.value / soma_total) * 100).toStringAsPrecision(2)}%',
          );
          list.add(data);
        }
        if (list.isEmpty) {
          final data = PieChartSectionData(
            color: Colors.grey,
            value: 100.0,
            radius: 40.0,
            title: ('100%'),
          );
          list.add(data);
          sectors.add(Sector(color: Colors.grey, value: 0.0, title: ('N/A')));
        }
        return list;
        break;
      case '3M':
        listTransacion.forEach((transact) {
          bool existe = false;
          categories.forEach((categoria) {
            if (transact.categoria.toString() == categoria) {
              existe = true;
            }
          });
          if (!existe) {
            List<String> campos = transact.data.split('-');
            int ano = int.parse(campos[0]);
            int mes = int.parse(campos[1]);
            int dia = int.parse(campos[2]);
            DateTime data_transact = DateTime(ano, mes, dia);
            if (transact.tipoTransacao == 1 &&
                (hoje.difference(data_transact).inDays <= 63)) {
              categories.add(transact.categoria.toString());
            }
          }
        });
        List<double> numbers = List.filled(categories.length, 0);
        int index = 0;
        categories.forEach((categoria) {
          listTransacion.forEach((transact) {
            List<String> campos = transact.data.split('-');
            int ano = int.parse(campos[0]);
            int mes = int.parse(campos[1]);
            int dia = int.parse(campos[2]);
            DateTime data_transact = DateTime(ano, mes, dia);
            if (transact.tipoTransacao == 1) {
              if (transact.categoria.toString() == categoria &&
                  (hoje.difference(data_transact).inDays <= 63)) {
                numbers[index] += transact.valor;
              }
            }
          });
          index++;
        });
        int index2 = 0;
        numbers.forEach((element) {
          sectors.add(Sector(
              color: widget.colors.elementAt(index2),
              value: numbers[index2],
              title: categories.elementAt(index2)));
          index2++;
        });
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
            title: (((sector.value / soma_total) * 100)
                        .toStringAsPrecision(2) ==
                    '1.0e+2')
                ? '100%'
                : '${((sector.value / soma_total) * 100).toStringAsPrecision(2)}%',
          );
          list.add(data);
        }
        if (list.isEmpty) {
          final data = PieChartSectionData(
            color: Colors.grey,
            value: 100.0,
            radius: 40.0,
            title: ('100%'),
          );
          list.add(data);
          sectors.add(Sector(color: Colors.grey, value: 0.0, title: ('N/A')));
        }
        return list;
        break;
      case '6M':
        listTransacion.forEach((transact) {
          bool existe = false;
          categories.forEach((categoria) {
            if (transact.categoria.toString() == categoria) {
              existe = true;
            }
          });
          if (!existe) {
            List<String> campos = transact.data.split('-');
            int ano = int.parse(campos[0]);
            int mes = int.parse(campos[1]);
            int dia = int.parse(campos[2]);
            DateTime data_transact = DateTime(ano, mes, dia);
            if (transact.tipoTransacao == 1 &&
                (hoje.difference(data_transact).inDays <= 186)) {
              categories.add(transact.categoria.toString());
            }
          }
        });
        List<double> numbers = List.filled(categories.length, 0);
        int index = 0;
        categories.forEach((categoria) {
          listTransacion.forEach((transact) {
            List<String> campos = transact.data.split('-');
            int ano = int.parse(campos[0]);
            int mes = int.parse(campos[1]);
            int dia = int.parse(campos[2]);
            DateTime data_transact = DateTime(ano, mes, dia);
            if (transact.tipoTransacao == 1) {
              if (transact.categoria.toString() == categoria &&
                  (hoje.difference(data_transact).inDays <= 186)) {
                numbers[index] += transact.valor;
              }
            }
          });
          index++;
        });
        int index2 = 0;

        numbers.forEach((element) {
          sectors.add(Sector(
              color: widget.colors.elementAt(index2),
              value: numbers[index2],
              title: categories.elementAt(index2)));
          index2++;
        });
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
            title: (((sector.value / soma_total) * 100)
                        .toStringAsPrecision(2) ==
                    '1.0e+2')
                ? '100%'
                : '${((sector.value / soma_total) * 100).toStringAsPrecision(2)}%',
          );
          list.add(data);
        }
        if (list.isEmpty) {
          final data = PieChartSectionData(
            color: Colors.grey,
            value: 100.0,
            radius: 40.0,
            title: ('100%'),
          );
          list.add(data);
          sectors.add(Sector(color: Colors.grey, value: 0.0, title: ('N/A')));
        }
        return list;
        break;
      case '1Y':
        listTransacion.forEach((transact) {
          bool existe = false;
          categories.forEach((categoria) {
            if (transact.categoria.toString() == categoria) {
              existe = true;
            }
          });
          if (!existe) {
            List<String> campos = transact.data.split('-');
            int ano = int.parse(campos[0]);
            int mes = int.parse(campos[1]);
            int dia = int.parse(campos[2]);
            DateTime data_transact = DateTime(ano, mes, dia);
            if (transact.tipoTransacao == 1 &&
                (hoje.difference(data_transact).inDays <= 365)) {
              categories.add(transact.categoria.toString());
            }
          }
        });
        List<double> numbers = List.filled(categories.length, 0);
        int index = 0;
        categories.forEach((categoria) {
          listTransacion.forEach((transact) {
            List<String> campos = transact.data.split('-');
            int ano = int.parse(campos[0]);
            int mes = int.parse(campos[1]);
            int dia = int.parse(campos[2]);
            DateTime data_transact = DateTime(ano, mes, dia);
            if (transact.tipoTransacao == 1) {
              if (transact.categoria.toString() == categoria &&
                  (hoje.difference(data_transact).inDays <= 365)) {
                numbers[index] += transact.valor;
              }
            }
          });
          index++;
        });
        int index2 = 0;
        numbers.forEach((element) {
          sectors.add(Sector(
              color: widget.colors.elementAt(index2),
              value: numbers[index2],
              title: categories.elementAt(index2)));
          index2++;
        });
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
            title: (((sector.value / soma_total) * 100)
                        .toStringAsPrecision(2) ==
                    '1.0e+2')
                ? '100%'
                : '${((sector.value / soma_total) * 100).toStringAsPrecision(2)}%',
          );
          list.add(data);
        }
        if (list.isEmpty) {
          final data = PieChartSectionData(
            color: Colors.grey,
            value: 100.0,
            radius: 40.0,
            title: ('100%'),
          );
          list.add(data);
          sectors.add(Sector(color: Colors.grey, value: 0.0, title: ('N/A')));
        }
        return list;
        break;
      default:
        {
          //statements;
        }
        return list;
    }
    // List<String> categories = [];
  }
}
