import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegistrarValores extends StatefulWidget {
  const RegistrarValores({super.key});

  @override
  State<RegistrarValores> createState() => _RegistrarValoresState();
}

class _RegistrarValoresState extends State<RegistrarValores> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text("Registrar valores"),
    );
  }
}
