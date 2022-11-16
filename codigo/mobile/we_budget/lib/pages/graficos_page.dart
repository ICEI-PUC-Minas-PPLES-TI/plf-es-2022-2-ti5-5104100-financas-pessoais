import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:we_budget/components/pie_chart_widget.dart';
import 'package:we_budget/models/transactions.dart';

import '../Repository/transaction_repository.dart';
import '../components/bar_chart_widget.dart';

import '../components/line_chart_widget.dart';

class Graficos_page extends StatefulWidget {
  const Graficos_page({Key? key}) : super(key: key);

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
              padding: EdgeInsets.only(right: 20.0, top: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.edit_calendar_sharp,
                  size: 26.0,
                ),
              )),
        ],
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
          padding: const EdgeInsets.only(
              left: 30.0, top: 30.0, right: 30.0, bottom: 100.0),
          child: Column(
            children: [
              const Text(
                'Despesas por categoria',
                style: TextStyle(fontSize: 24.0, fontFamily: 'Poppins'),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              PieChartWidget(listaTrasaction),
              const Text(
                'Receitas',
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'Poppins',
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              LineChartWidget(listaTrasaction),
              const Padding(padding: EdgeInsets.all(20)),
              const Text(
                'Despesas',
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'Poppins',
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              BarChartWidget(transactions: listaTrasaction),
            ],
          ),
        ),
      ),
    );
  }
}
