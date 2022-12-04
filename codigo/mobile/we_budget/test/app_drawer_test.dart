import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_budget/components/app_drawer.dart';

void main() {
  group("Teste AppDrawer", () {
    testWidgets("Teste widget 1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AppDrawer(),
      ));

      expect(find.text("Bem vindo usuário"), findsOneWidget);
    });
    testWidgets("Teste widget 2", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AppDrawer(),
      ));

      expect(find.text("Usuário"), findsOneWidget);
    });
    testWidgets("Teste widget 3", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AppDrawer(),
      ));

      expect(find.text("Logout"), findsOneWidget);
    });
  });
}
