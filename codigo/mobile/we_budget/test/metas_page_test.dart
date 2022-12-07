import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/Repository/metas_repository.dart';
import 'package:we_budget/pages/metas_page.dart';

void main() {
  testWidgets("Deve encontrar 3 Container's na pagina de metas", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryMetas(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryCategory('_token'),
        ),
      ],
      child: const MaterialApp(
        home: MetasPage(),
      ),
    ), Duration(seconds: 6));
    expect(find.byType(Container), findsNWidgets(3));
  });
  testWidgets("Deve encontrar 2 ElevatedButton's na pagina de metas",(WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryMetas(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryCategory('_token'),
        ),
      ],
      child: const MaterialApp(
        home: MetasPage(),
      ),
    ), Duration(seconds: 6));
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });
}