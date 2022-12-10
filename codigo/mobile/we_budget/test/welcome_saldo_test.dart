import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:we_budget/Repository/account_repository.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/components/welcome_saldo.dart';
import 'package:we_budget/models/auth.dart';
import 'package:we_budget/models/transactions.dart';
import 'package:we_budget/pages/welcome_page.dart';

void main() {
  testWidgets("Deve encontrar 9 Container`s na pagina de boas-vindas",
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryAccount(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryCategory(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: const MaterialApp(
        home: WelcomePage(),
      ),
    ));
    expect(find.byType(Container), findsNWidgets(18));
  });
  testWidgets("Deve encontrar 13 Padding`s na pagina de boas-vindas",
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryAccount(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryCategory(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: const MaterialApp(
        home: WelcomePage(),
      ),
    ));
    expect(find.byType(Padding), findsNWidgets(13));
  });
}
