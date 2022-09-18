import 'package:flutter/material.dart';

import 'login_page.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000)).then((_) {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(125, 218, 209, 211),
            Color.fromRGBO(255, 188, 117, 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.monetization_on,
            size: 200,
            color: Color.fromARGB(255, 160, 22, 13),
          ),
          Text("WEBUDGET",
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.overline,
              )),
        ],
      ),
    );
  }
}
