import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'dart:developer';

class ListTransactionsPage extends StatefulWidget {
  const ListTransactionsPage({super.key});
  @override
  State<ListTransactionsPage> createState() => _ListTransactionsPageState();
}

class _ListTransactionsPageState extends State<ListTransactionsPage> {
  int tipoTransferencia = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: size * 0.15,
        child: Container(
          margin: const EdgeInsetsDirectional.only(top: 20.0),
          child: Column(
            children: [
              ToggleSwitch(
                minWidth: 140.0,
                minHeight: 25.0,
                cornerRadius: 20.0,
                activeBgColors: const [
                  [Color.fromARGB(255, 67, 217, 255)],
                  [Color.fromARGB(255, 67, 217, 255)]
                ],
                borderWidth: 5,
                activeFgColor: Colors.white,
                inactiveBgColor: const Color.fromARGB(73, 158, 158, 158),
                inactiveFgColor: Colors.white,
                initialLabelIndex: 1,
                totalSwitches: 2,
                labels: const ['Despesa', 'Receita'],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                    tipoTransferencia = index!;
                  });
                  //tipoTransferencia = index;
                  print('switched to: $tipoTransferencia');
                },
              ),
              Container(
                width: 180,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1B1C30),
                        size: 20,
                      ),
                    ),
                    Text(
                      'Outubro - 2022',
                      style: TextStyle(
                        color: Color(0xFF1B1C30),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF1B1C30),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Filter(tipoTransferencia: tipoTransferencia),
    );
  }
}

class Filter extends StatefulWidget {
  const Filter({
    Key? key,
    required this.tipoTransferencia,
  }) : super(key: key);

  final int tipoTransferencia;

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<RepositoryTransaction>(context, listen: false)
          .loadTransactionRepository2(widget.tipoTransferencia),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(child: CircularProgressIndicator())
          : Consumer<RepositoryTransaction>(
              child: const Center(
                child: Text('Nenhum dado cadastrado!'),
              ),
              builder: (ctx, trasactionList, ch) => trasactionList.itemsCount ==
                      0
                  ? ch!
                  : ListView.builder(
                      itemCount: trasactionList.itemsCount,
                      itemBuilder: (ctx, i) => ListTile(
                            leading: const Icon(Icons.coffee),
                            title: Text(trasactionList.itemByIndex(i).name),
                            onTap: () {},
                            subtitle: Text(
                              DateFormat("dd/MM/yyyy").format(
                                DateTime.parse(
                                    trasactionList.itemByIndex(i).data),
                              ),
                            ),
                            trailing: Text(
                              trasactionList.itemByIndex(i).valor.toString(),
                            ),
                          )),
            ),
    );
  }
}
