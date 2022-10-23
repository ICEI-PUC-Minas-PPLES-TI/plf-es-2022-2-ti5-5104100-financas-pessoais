import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/models/auth.dart';
import 'package:we_budget/models/categoria_model.dart';
import 'package:we_budget/models/category.dart';
import 'package:we_budget/pages/auth_or_home_page.dart';
import 'package:we_budget/pages/category_page.dart';
import 'package:we_budget/pages/list_category_page.dart';
import 'package:we_budget/pages/login_page.dart';
import 'package:we_budget/pages/main_page.dart';
import 'package:we_budget/pages/registrar_transacao_page.dart';
import 'package:we_budget/providers/Transactions_providers.dart';
import 'package:we_budget/utils/app_routes.dart';
import 'package:we_budget/utils/db_util_novo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  void carregaBanco() async {
    Database db = await DBHelper.instance.database;
    /*await db.delete(DBHelper.tableCategoria);
    await db.delete(DBHelper.tableTransaction);*/
    await RepositoryCategory().selectCategoria();
    await RepositoryTransaction().selectTransaction();
  }

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Aplicação Inicial");
    carregaBanco();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => Category(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionsProviders(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryTransaction(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoryCategory(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blueGrey,
          ).copyWith(
            secondary: Colors.amber,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
          AppRoutes.login: (ctx) => const LoginPage(),
          AppRoutes.main: (ctx) => const MainPage(),
          AppRoutes.formTransaction: (ctx) => const TransacaoFormPage(),
          AppRoutes.listCategory: (ctx) => const ListCategoryPage(),
          AppRoutes.createCategory: (ctx) => const CreateCategory(),
        },
      ),
    );
  }
}
