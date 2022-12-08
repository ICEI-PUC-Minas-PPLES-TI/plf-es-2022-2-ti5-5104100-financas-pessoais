import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/components/card_main_page_balanco.dart';
import 'package:we_budget/components/edit_auth_form.dart';
import 'package:we_budget/models/auth.dart';

void main() {
  testWidgets("Deve encontrar 1 Card no widget edit_auth_form", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: const MaterialApp(
        home: UpdateAuthData(),
      ),
    ),Duration(seconds: 6));
    expect(find.byType(Card), findsOneWidget);
  });
}