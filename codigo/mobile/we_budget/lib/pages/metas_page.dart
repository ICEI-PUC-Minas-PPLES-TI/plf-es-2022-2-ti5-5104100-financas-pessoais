import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPage();
}

class _MetasPage extends State<MetasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
        child: AppBar(
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          flexibleSpace: const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Text(
              'Orçamento',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white70,
                fontSize: 30,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ),
          ],
          elevation: 0,
        ),
      ),
      backgroundColor: Colors.deepPurple,
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
                  Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                        Text(
                          'Outubro - 2022',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                    child: Container(
                      width: 100,
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            2, 2, 2, 2),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            const CircleBorder()),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
                                      ),
                                      child: const Icon(
                                        Icons.edit_rounded,
                                        color: Colors.white70,
                                        size: 10,
                                      ),
                                      onPressed: () {
                                        print('EditButton pressed ...');
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              5, 5, 5, 5),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              const CircleBorder()),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        onPressed: () {
                                          print('DeleteButton pressed ...');
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Icon(
                                    Icons.local_gas_station_rounded,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 5, 0),
                                  child: Text('Gasolina',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                      )),
                                ),
                                // Expanded(
                                //   child: Align(
                                //     alignment:  AlignmentDirectional(0.05, 0),
                                //     child: Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //       crossAxisAlignment:
                                //       CrossAxisAlignment.center,
                                //       children: [
                                //           Row(
                                //           mainAxisSize: MainAxisSize.max,
                                //           mainAxisAlignment: MainAxisAlignment.end,
                                //           children: [
                                //              Text(
                                //               'Meta do Mês',
                                //               textAlign: TextAlign.justify,
                                //               style: TextStyle(
                                //                 color: Colors.black,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //         Row(
                                //           mainAxisSize: MainAxisSize.max,
                                //           mainAxisAlignment:
                                //           MainAxisAlignment.end,
                                //           children: [
                                //              Text(
                                //               'R\$400,00',
                                //               style: TextStyle(
                                //                   color: Colors.black
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            5, 10, 5, 5),
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      animation: true,
                                      lineHeight: 20.0,
                                      animationDuration: 2500,
                                      percent: 0.4,
                                      center: const Text("160,00"),
                                      progressColor: Colors.green,
                                    )),
                              ],
                            ),
                          ],
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
    );
  }
}
