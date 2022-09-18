import 'package:flutter/material.dart';
import 'package:we_budget/pages/init_page.dart';
import 'package:we_budget/pages/login_page.dart';
import 'package:we_budget/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.home: (ctx) => const InitPage(),
        AppRoutes.login: (ctx) => const LoginPage(),
      },
    );
  }
}
