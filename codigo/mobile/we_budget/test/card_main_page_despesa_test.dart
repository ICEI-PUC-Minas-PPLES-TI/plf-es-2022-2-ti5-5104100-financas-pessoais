import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/components/card_main_page_despesa.dart';

void main() {
  testWidgets("Deve encontrar 1 Card no widget card_main_page_despesa",
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => RepositoryTransaction(),
            ),
          ],
          child: const MaterialApp(
            home: CardMainPageDespesa(),
          ),
        ),
        Duration(seconds: 6));
    expect(find.byType(Card), findsOneWidget);
  });
}
