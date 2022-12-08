import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_budget/components/bar_chart_widget.dart';

void main() {
  testWidgets("Deve encontrar 1 BarChart no widget BarChartWidget com o periodo igual a 'Máx'", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: BarChartWidget(transactions: [], periodo: 'Máx',),
    ));
    expect(find.byType(BarChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 BarChart no widget BarChartWidget com o periodo igual a '1M'", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: BarChartWidget(transactions: [], periodo: '1M',),
    ));
    expect(find.byType(BarChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 BarChart no widget BarChartWidget com o periodo igual a '3M'", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: BarChartWidget(transactions: [], periodo: '3M',),
    ));
    expect(find.byType(BarChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 BarChart no widget BarChartWidget com o periodo igual a '6M'", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: BarChartWidget(transactions: [], periodo: '6M',),
    ));
    expect(find.byType(BarChart), findsOneWidget);
  });
  testWidgets("Deve encontrar 1 BarChart no widget BarChartWidget com o periodo igual a '1Y'", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: BarChartWidget(transactions: [], periodo: '1Y',),
    ));
    expect(find.byType(BarChart), findsOneWidget);
  });
}