import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/account_repository.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/components/menu_component.dart';
import 'package:we_budget/models/auth.dart';

void main() {
  testWidgets("Deve encontrar 1 CurvedNavBar no widget menu_component",
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryCategory(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryAccount(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: const MaterialApp(
        home: MenuPrincipal(),
      ),
    ));
    expect(find.byType(CurvedNavBar), findsOneWidget);
  });
  testWidgets("Deve encontrar 7 Row's no widget menu_component",
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryCategory(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryAccount(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: const MaterialApp(
        home: MenuPrincipal(),
      ),
    ));
    expect(find.byType(Row), findsNWidgets(7));
  });
}
