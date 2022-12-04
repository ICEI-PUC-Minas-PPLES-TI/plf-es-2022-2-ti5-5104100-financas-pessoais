import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_budget/components/welcome_saldo.dart';

void main() {
  group("Teste AppDrawer", () {
    testWidgets("Teste widget 1", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: WelcomeSaldo(),
      ));

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
