import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/components/app_drawer.dart';
import 'package:mockito/mockito.dart';
import 'package:we_budget/components/date_picker.dart';
import 'package:we_budget/models/auth.dart';
import 'package:we_budget/pages/login_page.dart';
import 'package:we_budget/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
    testWidgets("Deve encontrar o texto 'Bem vindo usuário' dentro do widget AppDrawer", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AppDrawer(),
      ));

      expect(find.text("Bem vindo usuário"), findsOneWidget);
    });
    testWidgets("Deve encontrar o texto 'Usuário' dentro do widget AppDrawer", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AppDrawer(),
      ));

      expect(find.text("Usuário"), findsOneWidget);
    });
    testWidgets("Deve encontrar o texto 'Logout' dentro do widget AppDrawer", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AppDrawer(),
      ));

      expect(find.text("Logout"), findsOneWidget);
    });
    testWidgets("Deve encontrar 2 ListTile's dentro do widget AppDrawer", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AppDrawer(),
      ));
      expect(find.byType(ListTile), findsNWidgets(2));
    });
}
