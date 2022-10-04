import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/pages/first_page.dart';
import 'package:we_budget/pages/login_page.dart';
import 'package:we_budget/pages/main_page.dart';
import '../models/auth.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    //return auth.isAuth ? const MainPage() : const InitPage();
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? const MainPage() : const LoginPage();
        }
      },
    );
  }
}