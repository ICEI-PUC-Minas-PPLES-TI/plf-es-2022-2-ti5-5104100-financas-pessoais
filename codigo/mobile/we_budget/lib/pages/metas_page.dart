import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/utils/app_routes.dart';

import '../Repository/metas_repository.dart';
import '../Repository/transaction_repository.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPage();
}

class _MetasPage extends State<MetasPage> {
  String formattedDate = '01/01/2022';
  DateTime? pickedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: AppBar(
            backgroundColor: const Color(0xFFF4F4F4),
            automaticallyImplyLeading: false,
            flexibleSpace: const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
              child: Text(
                'Metas',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF5B4BF8),
                  fontSize: 30,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const CircleBorder()),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF5B4BF8)),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.createMeta);
                  },
                ),
              ),
            ],
            elevation: 0,
          ),
        ),
        backgroundColor: const Color(0xFFF4F4F4),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 1.0, top: 0.0, right: 0.0, bottom: 0.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B1C30),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Filter extends StatefulWidget {
  const Filter({
    Key? key,
    required this.filtroData,
  }) : super(key: key);

  final String filtroData;

  @override
  State<Filter> createState() => _ListMetas();
}

class _ListMetas extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<RepositoryMetas>(context, listen: false)
          .loadMetasRepository2(widget.filtroData),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(child: CircularProgressIndicator())
          : Consumer<RepositoryMetas>(
              child: const Center(
                child: Text('Nenhum dado cadastrado!'),
              ),
              builder: (ctx, metasList, ch) => metasList.itemsCount == 0
                  ? ch!
                  : ListView.builder(
                      itemCount: metasList.itemsCount,
                      itemBuilder: (ctx, i) => Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                        child: Container(
                          width: 100,
                          height: 170,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1C30),
                            borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 15, 15, 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              const CircleBorder()),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFFF4F4F4)),
                                        ),
                                        child: const Icon(
                                          Icons.edit_rounded,
                                          color: Color(0xFF5B4BF8),
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          print('EditButton pressed ...');
                                        },
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              const CircleBorder()),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            const Color(0xFFF4F4F4),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Color(0xFF5B4BF8),
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          // Provider.of<RepositoryMetas>(
                                          //         context,
                                          //         listen: false)
                                          //     .removeMetaSql(metasList
                                          //         .itemByIndex(i)
                                          //         .idTransaction);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5, 5, 5, 5),
                                      child: Icon(
                                        Icons.card_travel,
                                        color: Color(0xFFF4F4F4),
                                        size: 30,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5, 0, 5, 0),
                                      child: Text(
                                        'Viagem',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 20,
                                          color: Color(0xFFF4F4F4),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(0.05, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                Text(
                                                  'Meta do Mês',
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                Text(
                                                  'R\$300,00',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              5, 5, 5, 5),
                                      child: LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                80,
                                        animation: true,
                                        lineHeight: 20.0,
                                        animationDuration: 2500,
                                        percent: 0.5,
                                        center: const Text(
                                          "30,00",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF1B1C30),
                                          ),
                                        ),
                                        progressColor: const Color(0xFF4C94F8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
    );
  }
}
