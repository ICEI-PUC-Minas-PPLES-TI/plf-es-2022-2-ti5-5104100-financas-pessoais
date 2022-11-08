import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:month_year_picker/month_year_picker.dart';

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
    TextEditingController dateInput = TextEditingController();
    String formattedDate = '01/01/2022';
    DateTime? pickedDate;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: size * 0.17,
        child: Container(
          margin: const EdgeInsetsDirectional.only(top: 20.0),
          child: Column(
            children: [
              ToggleSwitch(
                minWidth: 140.0,
                minHeight: 26.0,
                cornerRadius: 20.0,
                activeBgColors: const [
                  [Color.fromARGB(255, 67, 217, 255)],
                  [Color.fromARGB(255, 67, 217, 255)]
                ],
                borderWidth: 5,
                activeFgColor: Colors.white,
                inactiveBgColor: const Color.fromARGB(73, 158, 158, 158),
                inactiveFgColor: Colors.white,
                initialLabelIndex: tipoTransferencia,
                totalSwitches: 2,
                labels: const ['Despesa', 'Receita'],
                radiusStyle: true,
                onToggle: (index) {
                  tipoTransferencia = index!;
                  //tipoTransferencia = index
                  setState(() {
                    print('switched to: $tipoTransferencia');
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 1.0, top: 0.0, right: 1.0, bottom: 0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fixedSize: const Size(200, 10),
                  ),
                  onPressed: () async {
                    print("entrei");
                    pickedDate = await showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
                      builder: (context, child) {
                        return SizedBox(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(),
                              textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom()),
                            ),
                            child: child!,
                          ),
                        );
                      },
                    );
                    if (pickedDate != null) {
                      formattedDate =
                          DateFormat("dd/MM/yyyy").format(pickedDate!);
                      print(formattedDate);
                    }
                  },
                  child: const Text('Filtrar Data'),
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
