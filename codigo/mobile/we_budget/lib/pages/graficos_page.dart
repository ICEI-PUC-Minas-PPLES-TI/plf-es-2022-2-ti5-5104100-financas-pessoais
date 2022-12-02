import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/components/categoria_dropdown.dart';
import 'package:we_budget/components/pie_chart_widget.dart';
import 'package:we_budget/models/categoria_model.dart';
import 'package:we_budget/models/categoria_model.dart';
import 'package:we_budget/models/transactions.dart';
import 'package:we_budget/pages/location_form.dart';

import '../Repository/transaction_repository.dart';
import '../components/bar_chart_widget.dart';
import '../components/date_picker.dart';
import '../components/forma_pagamento_dropdown.dart';

import '../components/line_chart_widget.dart';
import '../components/pie_chart_widget2.dart';
import '../components/price_point.dart';
import '../exceptions/auth_exception.dart';
import '../models/store.dart';
import '../utils/app_routes.dart';

class Graficos_page extends StatefulWidget {
  Graficos_page({Key? key}) : super(key: key);
  String id_periodo_late = 'Máx';
  int id_grafico = 0;
  @override
  State<Graficos_page> createState() => _GraficosPageState();
}

class _GraficosPageState extends State<Graficos_page> {
  void onClicado(int index) {
    setState(() {
      widget.id_grafico = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int id = widget.id_grafico;
    RepositoryTransaction transaction = Provider.of(context);
    List<TransactionModel> listanova = transaction.getAll();
    List<TransactionModel> listaTrasaction = [];

    for (var element in listanova) {
      listaTrasaction.add(
        TransactionModel(
            idTransaction: element.idTransaction,
            name: element.name,
            categoria: Provider.of<RepositoryCategory>(context, listen: false)
                .selectNameCategoria(element.categoria),
            data: element.data,
            valor: element.valor,
            formaPagamento: element.formaPagamento,
            location: element.location,
            tipoTransacao: element.tipoTransacao),
      );
    }
    int? index;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: NewGradientAppBar(
          gradient:
              const LinearGradient(colors: [Colors.purple, Colors.blueAccent]),
          bottom: TabBar(
            tabs: <Widget>[
              const Tab(
                icon: Icon(Icons.pie_chart),
                text: 'Despesas',
              ),
              const Tab(
                icon: Icon(Icons.pie_chart),
                text: 'Receitas',
              ),
              const Tab(
                icon: Icon(Icons.bar_chart),
                text: 'Despesas',
              ),
              const Tab(
                icon: Icon(Icons.stacked_line_chart_outlined),
                text: 'Receitas',
              )
            ],
            onTap: onClicado,
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 30.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        String id_Periodo = widget.id_periodo_late;
                        return Container(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PeriodoButton(
                                '1M',
                                onPressed: () => setState(() {
                                  id_Periodo = '1M';
                                  widget.id_periodo_late = '1M';
                                  Navigator.pop(context);
                                }),
                                selected: (id_Periodo == '1M' ||
                                    widget.id_periodo_late == '1M'),
                              ),
                              PeriodoButton(
                                '3M',
                                onPressed: () => setState(() {
                                  widget.id_periodo_late = '3M';
                                  Navigator.pop(context);
                                }),
                                selected: id_Periodo == '3M' ||
                                    widget.id_periodo_late == '3M',
                              ),
                              PeriodoButton(
                                '6M',
                                onPressed: () => setState(() {
                                  widget.id_periodo_late = '6M';
                                  Navigator.pop(context);
                                }),
                                selected: id_Periodo == '6M' ||
                                    widget.id_periodo_late == '6M',
                              ),
                              // PeriodoButton(
                              //     '1Y',
                              //   onPressed: () => setState(() {
                              //     widget.id_periodo_late = '1Y';
                              //     Navigator.pop(context);
                              //   }),
                              //   selected: id_Periodo == '1Y' || widget.id_periodo_late == '1Y',
                              // ),
                              PeriodoButton(
                                'Máx',
                                onPressed: () => setState(() {
                                  widget.id_periodo_late = 'Máx';
                                  Navigator.pop(context);
                                }),
                                selected: id_Periodo == 'Máx' ||
                                    widget.id_periodo_late == 'Máx',
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.edit_calendar_sharp,
                    size: 26.0,
                  ),
                )),
          ],
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                const Center(child: Text('Gráficos')),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, top: 30.0, right: 30.0, bottom: 100.0),
              child: (id == 0)
                  ? Column(children: [
                      const Text(
                        'Despesas por categoria',
                        style: TextStyle(fontSize: 24.0, fontFamily: 'Poppins'),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      PieChartWidget(
                        listaTrasaction,
                        periodo: widget.id_periodo_late,
                      ),
                    ])
                  : (id == 1)
                      ? Column(
                          children: [
                            const Text(
                              'Receitas por categoria',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            PieChartWidget2(
                              listaTrasaction,
                              periodo: widget.id_periodo_late,
                            ),
                          ],
                        )
                      : (id == 2)
                          ? Column(
                              children: [
                                const Text(
                                  'Despesas',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(10)),
                                BarChartWidget(
                                  transactions: listaTrasaction,
                                  periodo: widget.id_periodo_late,
                                ),
                              ],
                            )
                          : (id == 3)
                              ? Column(
                                  children: [
                                    const Text(
                                      'Receitas',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(10)),
                                    LineChartWidget(listaTrasaction,
                                        periodo: widget.id_periodo_late),
                                  ],
                                )
                              : const Text('opcao invalida')),
        ),
      ),
    );
  }
}

void _alterarOId(int id) {}

class PeriodoButton extends StatelessWidget {
  final String text;
  final bool? selected;
  final VoidCallback onPressed;

  const PeriodoButton(
    this.text, {
    Key? key,
    required this.onPressed,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        '$text \n____________',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          color: selected == true ? Colors.blueAccent : null,
          fontWeight: selected == true ? FontWeight.bold : null,
        ),
      ),
    );
  }
}
