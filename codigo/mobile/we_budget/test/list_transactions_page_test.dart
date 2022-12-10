import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/account_repository.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/components/card_main_page_balanco.dart';
import 'package:we_budget/pages/list_transactions_page.dart';

void main() {
  testWidgets("Deve encontrar 12 Container`s na pagina de lista de transações",
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => RepositoryCategory(),
            ),
            ChangeNotifierProvider(
              create: (_) => RepositoryTransaction(),
            ),
          ],
          child: const MaterialApp(
            home: ListTransactionsPage(),
          ),
        ),
        Duration(seconds: 6));
    expect(find.byType(Container), findsNWidgets(12));
  });
}
