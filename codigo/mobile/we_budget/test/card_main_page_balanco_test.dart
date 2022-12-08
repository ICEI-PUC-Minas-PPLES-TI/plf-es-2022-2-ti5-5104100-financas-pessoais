import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/account_repository.dart';
import 'package:we_budget/components/card_main_page_balanco.dart';

void main() {
  testWidgets("Deve encontrar 4 Container's no widget card_main_page_balanco", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryAccount('_token'),
        ),
      ],
      child: const MaterialApp(
        home: CardMainPageBalanco(),
      ),
    ));
    expect(find.byType(Container), findsNWidgets(4));
  });
}

