import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ListTransationsPage extends StatefulWidget {
  const ListTransationsPage({super.key});
  @override
  State<ListTransationsPage> createState() => _ListTransationsPageState();
}

class _ListTransationsPageState extends State<ListTransationsPage> {
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
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFC84CF4),
                    Color.fromARGB(255, 41, 19, 236),
                    Color(0xFF923DF8),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ToggleSwitch(
                          minWidth: 120.0,
                          minHeight: 25.0,
                          cornerRadius: 20.0,
                          activeBgColors: const [
                            [Color.fromARGB(255, 67, 217, 255)],
                            [Color.fromARGB(255, 67, 217, 255)]
                          ],
                          borderWidth: 5,
                          activeFgColor: Colors.white,
                          inactiveBgColor:
                              const Color.fromARGB(73, 158, 158, 158),
                          inactiveFgColor: Colors.white,
                          initialLabelIndex: 1,
                          totalSwitches: 2,
                          labels: const ['Despesa', 'Receita'],
                          radiusStyle: true,
                          onToggle: (index) {
                            print('switched to: $index');
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 180,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
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
            Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsetsDirectional.only(start: 6.0, end: 6.0),
                  height: size.height * 0.85,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
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
                  child: Column(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
