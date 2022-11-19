import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/Repository/metas_repository.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/models/auth.dart';
import 'package:we_budget/pages/auth_or_home_page.dart';
import 'package:we_budget/pages/category_page.dart';
import 'package:we_budget/pages/create_meta.dart';
import 'package:we_budget/pages/list_category_page.dart';
import 'package:we_budget/pages/list_transactions_page.dart';
import 'package:we_budget/pages/location_form.dart';
import 'package:we_budget/pages/login_page.dart';
import 'package:we_budget/pages/main_page.dart';
import 'package:we_budget/pages/registrar_transacao_page.dart';
import 'package:we_budget/providers/Transactions_providers.dart';
import 'package:we_budget/utils/app_routes.dart';
import 'package:we_budget/utils/db_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  void carregaBanco() async {
    Database db = await DBHelper.instance.database;
    /*await db.delete(DBHelper.tableCategoria);
    await db.delete(DBHelper.tableTransaction);*/
    await RepositoryCategory('').selectCategoria();
    await RepositoryTransaction('').selectTransaction();
    await RepositoryMetas().selectMetas();
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
          create: (_) => TransactionsProviders(),
        ),
        ChangeNotifierProxyProvider<Auth, RepositoryTransaction>(
          create: (_) => RepositoryTransaction(''),
          update: (context, auth, previous) {
            return RepositoryTransaction(auth.token ?? '');
          },
        ),
        ChangeNotifierProxyProvider<Auth, RepositoryCategory>(
          create: (_) => RepositoryCategory(''),
          update: (context, auth, previous) {
            return RepositoryCategory(auth.token ?? '');
          },
        ),
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
        localizationsDelegates: const [
          MonthYearPickerLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
          AppRoutes.login: (ctx) => const LoginPage(),
          AppRoutes.main: (ctx) => const MainPage(),
          AppRoutes.formTransaction: (ctx) => const TransacaoFormPage(),
          AppRoutes.listCategory: (ctx) => const ListCategoryPage(),
          AppRoutes.createCategory: (ctx) => const CreateCategory(),
          AppRoutes.placeForm: (ctx) => const PlaceFormScreen(),
          AppRoutes.listTransactions: (ctx) => const ListTransactionsPage(),
          AppRoutes.createMeta: (ctx) => const CreateMeta(),
        },
      ),
    );
  }
}
