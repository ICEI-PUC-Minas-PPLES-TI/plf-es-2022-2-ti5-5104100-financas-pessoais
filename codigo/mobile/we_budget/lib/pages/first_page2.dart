import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FirstPage2 extends StatefulWidget {
  const FirstPage2({super.key});

  @override
  State<FirstPage2> createState() => _FirtsPageState();
}

class _FirtsPageState extends State<FirstPage2> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 69, 8, 168),
              ),
              width: double.infinity,
              height: size.height * 0.3,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 170,
                ),
                Container(
                  width: double.infinity,
                  height: size.height * 0.75,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 8,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: Colors.blueAccent,
                              ),
                              child: Column(
                                children: const <Widget>[
                                  Text(
                                    "Receita",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 8,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: Colors.blueAccent,
                              ),
                              child: Column(
                                children: const <Widget>[
                                  Text(
                                    "Despesa",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 8,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: Colors.blueAccent,
                              ),
                              child: Column(
                                children: const <Widget>[
                                  Text(
                                    "Balanço",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
