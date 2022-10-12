import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/models/auth.dart';
import 'package:we_budget/models/category.dart';
import 'package:we_budget/pages/auth_or_home_page.dart';
import 'package:we_budget/pages/login_page.dart';
import 'package:we_budget/pages/main_page.dart';
import 'package:we_budget/utils/app_routes.dart';

import 'pages/record_transactions_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => Category(),
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
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
          AppRoutes.login: (ctx) => const LoginPage(),
          AppRoutes.main: (ctx) => const MainPage(),
          AppRoutes.FORM_TRANSACTIONS: (ctx) => const TransacaoFormPage()
        },
      ),
    );
  }
}
