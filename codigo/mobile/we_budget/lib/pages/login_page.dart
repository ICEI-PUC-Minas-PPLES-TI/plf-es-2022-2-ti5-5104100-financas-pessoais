import 'dart:math';

import 'package:flutter/material.dart';
import 'package:we_budget/components/auth_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(125, 153, 12, 48),
                  Color.fromARGB(228, 165, 99, 28),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 70,
                  ),
                  // cascade operator
                  //transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepOrange.shade900,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'WeBudget',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Anton',
                      color: Colors.white,
                    ),
                  ),
                ),
                const AuthForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
