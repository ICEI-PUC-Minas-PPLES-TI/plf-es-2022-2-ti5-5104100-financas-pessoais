import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/account_repository.dart';
import 'package:we_budget/pages/registrar_transacao_page.dart';

void main() {
  testWidgets("Deve encontrar 18 Container`s na pagina de cafastrar transações", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryAccount('_token'),
        ),
      ],
      child: const MaterialApp(
        home: TransacaoFormPage(),
      ),
    ));
    expect(find.byType(Container), findsNWidgets(18));
  });
}