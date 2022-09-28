import 'package:flutter/cupertino.dart';

class ListaTransacoes extends StatefulWidget {
  const ListaTransacoes({super.key});

  @override
  State<ListaTransacoes> createState() => _ListaTransacoesState();
}

class _ListaTransacoesState extends State<ListaTransacoes> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Lista transações"),
    );
  }
}
