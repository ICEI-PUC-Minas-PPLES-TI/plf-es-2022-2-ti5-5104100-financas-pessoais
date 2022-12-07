import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/components/bar_chart_widget.dart';
import 'package:we_budget/components/line_chart_widget.dart';
import 'package:we_budget/components/pie_chart_widget.dart';
import 'package:we_budget/components/pie_chart_widget2.dart';
import 'package:we_budget/pages/graficos_page.dart';

void main() {
  testWidgets("Deve encontrar 6 Container's na pagina de gráficos", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction('_token'),
        ),
      ],
      child: MaterialApp(
        home: Graficos_page(),
      ),
    ),Duration(seconds: 6));
    expect(find.byType(Container), findsNWidgets(6));
  });
  testWidgets("Deve encontrar 6 GestureDetector's na pagina de gráficos", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction('_token'),
        ),
      ],
      child: MaterialApp(
        home: Graficos_page(),
      ),
    ), Duration(seconds: 6));
    expect(find.byType(GestureDetector), findsNWidgets(5));
  });
    testWidgets("Após clicar no ícone stacked_line_chart_outlined, deve encontrar 1 LineChartWidget na pagina de gráficos", (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RepositoryTransaction('_token'),
          ),
        ],
        child: MaterialApp(
          home: Graficos_page(),
        ),
      ),Duration(seconds: 6));

      await tester.tap(find.byIcon(Icons.stacked_line_chart_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(LineChartWidget), findsOneWidget);
  });
  testWidgets("Após clicar no primeiro ícone pie_chart, deve encontrar 1 PieChart na pagina de gráficos", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction('_token'),
        ),
      ],
      child: MaterialApp(
        home: Graficos_page(),
      ),
    ),Duration(seconds: 6));

    await tester.tap(find.byIcon(Icons.pie_chart).first);
    await tester.pumpAndSettle();
    expect(find.byType(PieChartWidget), findsOneWidget);

  });
  testWidgets("Após clicar no último ícone pie_chart, deve encontrar 1 PieChart na pagina de gráficos", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction('_token'),
        ),
      ],
      child: MaterialApp(
        home: Graficos_page(),
      ),
    ),Duration(seconds: 6));

    await tester.tap(find.byIcon(Icons.pie_chart).last);
    await tester.pumpAndSettle();
    expect(find.byType(PieChartWidget2), findsOneWidget);

  });
  testWidgets("Após clicar no ícone bar_chart, deve encontrar 1 BarChart na pagina de gráficos", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction('_token'),
        ),
      ],
      child: MaterialApp(
        home: Graficos_page(),
      ),
    ),Duration(seconds: 6));

    await tester.tap(find.byIcon(Icons.bar_chart).last);
    await tester.pumpAndSettle();
    expect(find.byType(BarChartWidget), findsOneWidget);

  });

  testWidgets("Após clicar no ícone edit_calendar_sharp, deve encontrar 1 Container na pagina de gráficos", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction('_token'),
        ),
      ],
      child: MaterialApp(
        home: Graficos_page(),
      ),
    ),Duration(seconds: 6));

    await tester.tap(find.byIcon(Icons.edit_calendar_sharp));
    await tester.pumpAndSettle();
    expect(find.byType(Container), findsNWidgets(7));

  });
}