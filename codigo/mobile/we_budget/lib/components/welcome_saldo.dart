import 'package:flutter/material.dart';

class WelcomeSaldo extends StatelessWidget {
  final String? texto;
  final double? size;

  const WelcomeSaldo({
    this.texto,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "$texto",
        style: TextStyle(
          color: Colors.white,
          fontSize: size,
        ),
      ),
    );
  }
}
