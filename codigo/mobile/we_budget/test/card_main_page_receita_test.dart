import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/components/card_main_page_receita.dart';

void main() {
  testWidgets("Deve encontrar 4 Container's no widget AppDrawer",
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => RepositoryTransaction(),
            ),
          ],
          child: const MaterialApp(
            home: CardMainPageReceita(),
          ),
        ),
        Duration(seconds: 6));
    expect(find.byType(Container), findsNWidgets(4));
  });
}
