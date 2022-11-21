import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
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
  @override
  State<Graficos_page> createState() => _GraficosPageState();
}

class _GraficosPageState extends State<Graficos_page> {
  @override
  Widget build(BuildContext context) {
    RepositoryTransaction transaction = Provider.of(context);
    List<TransactionModel> listaTrasaction = transaction.getAll();
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
      Padding(
      padding: EdgeInsets.only(right: 20.0,top: 20.0),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                String id_Periodo = widget.id_periodo_late;
                return Container(
                  padding: EdgeInsets.only(top: 20.0,bottom: 15.0),
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
                            selected: (id_Periodo == '1M' || widget.id_periodo_late == '1M'),
                          ),
                          PeriodoButton(
                              '3M',
                            onPressed: () => setState((){
                              widget.id_periodo_late = '3M';
                              Navigator.pop(context);
                            }),
                            selected: id_Periodo == '3M' || widget.id_periodo_late == '3M',
                          ),
                          PeriodoButton(
                              '6M',
                            onPressed: () => setState(() {
                              widget.id_periodo_late = '6M';
                              Navigator.pop(context);
                            }),
                            selected: id_Periodo == '6M' || widget.id_periodo_late == '6M',
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
                            selected: id_Periodo == 'Máx' || widget.id_periodo_late == 'Máx',
                          ),
                        ],
                      ),
                );
              },
            );
          },
          child: Icon(
            Icons.edit_calendar_sharp,
            size: 26.0,
          ),
        )
    ),],
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Center(child: Text('Gráficos')),
            ],
          ),
        ),
        backgroundColor: Colors.blueAccent,

      ),
      body: SingleChildScrollView(
        child: Padding(
    padding: const EdgeInsets.only(left: 30.0, top: 30.0, right: 30.0, bottom: 100.0),
          child: Column(
            children: [
              const Text(
                'Despesas por categoria',
                style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'Poppins'
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              PieChartWidget(listaTrasaction, periodo: widget.id_periodo_late,),
              const Padding(padding: EdgeInsets.all(10)),
              const Text(
            'Receitas por categoria',
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'Poppins',
            ),),
              const Padding(padding: EdgeInsets.all(10)),
              PieChartWidget2(listaTrasaction, periodo: widget.id_periodo_late,),
          const Text(
                      'Receitas',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
              const Padding(padding: EdgeInsets.all(10)),
              LineChartWidget(listaTrasaction, periodo: widget.id_periodo_late),
                const Padding(padding: EdgeInsets.all(20)),
                const Text(
                  'Despesas',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'Poppins',
                  ),
                ),
              const Padding(padding: EdgeInsets.all(10)),
                BarChartWidget(transactions: listaTrasaction, periodo: widget.id_periodo_late,),
            ],
          ),
        ),
      ),
    );
  }

}
class PeriodoButton extends StatelessWidget {
  final String text;
  final bool? selected;
  final VoidCallback onPressed;

  const PeriodoButton(this.text, {
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
          color:
          selected == true ? Colors.blueAccent : null,
          fontWeight: selected == true ? FontWeight.bold : null,
        ),
      ),
    );
  }
}