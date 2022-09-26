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
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: deviceSize.height * 0.15,
                child: SizedBox.expand(
                  child: Image.asset(
                    'assets/bola.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                child: const AuthForm(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
