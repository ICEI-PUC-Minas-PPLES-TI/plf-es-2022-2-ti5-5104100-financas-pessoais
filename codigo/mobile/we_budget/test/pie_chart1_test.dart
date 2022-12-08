import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_budget/components/pie_chart_widget.dart';

void main() {
  testWidgets("Deve encontrar 1 PieChart no widget PieChartWidget com o periodo igual a 'Máx'", (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(
      home: PieChartWidget(listTransacion: [], periodo: 'Máx',),
    ));
    expect(find.byType(Column), findsNWidgets(2 ));
  });
  testWidgets("Deve encontrar 1 PieChart no widget PieChartWidget com o periodo igual a '1M'", (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(
      home: PieChartWidget(listTransacion: [], periodo: '1M',),
    ));
    expect(find.byType(PieChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 PieChart no widget PieChartWidget com o periodo igual a '3M'", (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(
      home: PieChartWidget(listTransacion: [], periodo: '3M',),
    ));
    expect(find.byType(PieChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 PieChart no widget PieChartWidget com o periodo igual a '6M'", (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(
      home: PieChartWidget(listTransacion: [], periodo: '6M',),
    ));
    expect(find.byType(PieChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 PieChart no widget PieChartWidget com o periodo igual a '1Y'", (WidgetTester tester) async {
    await tester.pumpWidget( MaterialApp(
      home: PieChartWidget(listTransacion: [], periodo: '1Y',),
    ));
    expect(find.byType(PieChart), findsOneWidget);
  });
}