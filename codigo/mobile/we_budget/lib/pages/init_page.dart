import 'package:flutter/material.dart';
import 'package:we_budget/pages/login_page.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000)).then(
      (_) {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Image.asset('assets/logo.jpeg'),
      ),
    );
  }
}
