import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_budget/pages/login_page.dart';

void main() {
  testWidgets("Deve encontrar 1 SingleChildScrollView na pagina de login", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginPage(),
    ));

    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}