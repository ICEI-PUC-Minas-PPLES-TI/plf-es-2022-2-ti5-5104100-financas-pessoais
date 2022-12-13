import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_budget/components/auth_form.dart';

void main() {
  testWidgets("Deve encontrar 1 Form no widget auth_form", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AuthForm(),
    ));

    expect(find.byType(Form), findsOneWidget);
  });
}