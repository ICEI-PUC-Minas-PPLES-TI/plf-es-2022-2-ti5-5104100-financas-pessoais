import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/utils/app_routes.dart';

class ListTransactionsPage extends StatefulWidget {
  const ListTransactionsPage({super.key});
  @override
  State<ListTransactionsPage> createState() => _ListTransactionsPageState();
}

class _ListTransactionsPageState extends State<ListTransactionsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<RepositoryCategory>(context, listen: false)
        .loadCategoryRepository();
  }

  int tipoTransferencia = 0;
  String formattedDate = DateFormat("yyyy-MM").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateTime? pickedDate;
    DateTime? dataSelecionada = DateTime.now();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: size * 0.18,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF923DF8),
                Color(0xFF4C94F8),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          margin: const EdgeInsetsDirectional.only(top: 20.0),
          child: Container(
            margin: const EdgeInsetsDirectional.only(top: 30.0),
            child: Column(
              children: [
                ToggleSwitch(
                  minWidth: 140.0,
                  minHeight: 26.0,
                  cornerRadius: 20.0,
                  activeBgColors: const [
                    [Color(0xFF1B1C30)],
                    [Color(0xFF1B1C30)]
                  ],
                  borderWidth: 5,
                  activeFgColor: Colors.white,
                  inactiveBgColor: const Color.fromARGB(73, 158, 158, 158),
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: tipoTransferencia,
                  fontSize: 15,
                  totalSwitches: 2,
                  labels: const ['Receita', 'Despesa'],
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
                      left: 1.0, top: 0.0, right: 1.0, bottom: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B1C30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fixedSize: const Size(200, 10),
                    ),
                    onPressed: () async {
                      pickedDate = await showMonthYearPicker(
                        context: context,
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
                        initialDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          formattedDate =
                              DateFormat("yyyy-MM").format(pickedDate!);
                        });
                      }
                    },
                    child: const Text(
                      'Filtrar Data',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 253, 253, 252),
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(20),
            topEnd: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Filter(
          tipoTransferencia: tipoTransferencia,
          filtroData: formattedDate,
        ),
      ),
    );
  }
}

class Filter extends StatefulWidget {
  const Filter({
    Key? key,
    required this.tipoTransferencia,
    required this.filtroData,
  }) : super(key: key);

  final int tipoTransferencia;
  final String filtroData;

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<RepositoryTransaction>(context, listen: false)
          .loadTransactionRepository2(
              widget.tipoTransferencia, widget.filtroData),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(child: CircularProgressIndicator())
          : Consumer<RepositoryTransaction>(
              child: const Center(
                child: Text('Nenhum dado cadastrado!'),
              ),
              builder: (ctx, trasactionList, ch) =>
                  trasactionList.itemsCount == 0
                      ? ch!
                      : ListView.builder(
                          itemCount: trasactionList.itemsCount,
                          itemBuilder: (ctx, i) => Dismissible(
                            background: Container(
                              color: const Color(0xFF45CFF1),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const <Widget>[
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    Text(
                                      " Editar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const <Widget>[
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    Text(
                                      " Excluir",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                Provider.of<RepositoryTransaction>(context,
                                        listen: false)
                                    .removeTransactionSql(trasactionList
                                        .itemByIndex(i)
                                        .idTransaction);
                              } else {
                                setState(() {
                                  Map<String, dynamic> arguments = {
                                    'page': 'listTransaction',
                                    'itemByIndex':
                                        trasactionList.itemByIndex(i),
                                  };
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.formTransaction,
                                    arguments: arguments,
                                  );
                                });
                              }
                            },
                            key: ValueKey(
                                trasactionList.itemByIndex(i).idTransaction),
                            child: ListTile(
                              leading: Icon(
                                IconData(
                                    Provider.of<RepositoryCategory>(context,
                                            listen: false)
                                        .codeCategory(
                                      trasactionList.itemByIndex(i).categoria,
                                    ),
                                    fontFamily: "MaterialIcons"),
                              ),
                              title: Text(trasactionList.itemByIndex(i).name),
                              onTap: () {},
                              subtitle: Text(
                                DateFormat("dd/MM/yyyy").format(
                                  DateTime.parse(
                                      trasactionList.itemByIndex(i).data),
                                ),
                              ),
                              trailing: Text(
                                trasactionList
                                    .itemByIndex(i)
                                    .valor
                                    .toStringAsFixed(2)
                                    .replaceAll('.', ','),
                              ),
                            ),
                          ),
                        ),
            ),
    );
  }
}
