import 'package:flutter/material.dart';
import 'auth_or_home_page.dart';

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
            builder: (context) => const AuthOrHomePage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F4F4),
      ),
      child: Center(
        child: Image.asset('assets/logo.jpeg'),
      ),
    );
  }
}
