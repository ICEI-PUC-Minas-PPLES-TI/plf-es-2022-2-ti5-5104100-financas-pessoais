import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_budget/components/pie_chart_widget.dart';
import 'package:we_budget/components/pie_chart_widget2.dart';
import 'package:we_budget/models/transactions.dart';

void main() {
  var trsnc = TransactionModel(idTransaction: '0', name: 'name', categoria: 'categoria', data: '2022-10-21', valor: 50.0, formaPagamento: 'Pix', location: TransactionLocation(latitude: 20.0, longitude: 20.0), tipoTransacao: 1);
  var list = <TransactionModel>  [];
  list.add(trsnc);
  testWidgets("Deve encontrar 1 PieChart no widget PieChartWidget2 com o periodo igual a 'Máx'", (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(
      home: SingleChildScrollView(child: PieChartWidget2(listTransacion: list, periodo: 'Máx',)),
    ));
    expect(find.byType(PieChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 PieChart no widget PieChartWidget2 com o periodo igual a '1M'", (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(
      home: PieChartWidget2(listTransacion: list, periodo: '1M',),
    ));
    expect(find.byType(PieChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 PieChart no widget PieChartWidget2 com o periodo igual a '3M'", (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(
      home: PieChartWidget2(listTransacion: list, periodo: '3M',),
    ));
    expect(find.byType(PieChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 PieChart no widget PieChartWidget2 com o periodo igual a '6M'", (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(
      home: PieChartWidget2(listTransacion: list, periodo: '6M',),
    ));
    expect(find.byType(PieChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 PieChart no widget PieChartWidget2 com o periodo igual a '1Y'", (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(
      home: PieChartWidget2(listTransacion: list, periodo: '1Y',),
    ));
    expect(find.byType(PieChart), findsOneWidget);
  });
}