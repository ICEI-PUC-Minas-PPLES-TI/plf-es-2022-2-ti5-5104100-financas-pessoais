import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    final deviceSizeWidth = MediaQuery.of(context).size.width;
    final deviceSizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela inicial"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: deviceSizeWidth * 1.0,
                height: deviceSizeHeight * 0.26,
                child: Card(
                  color: Colors.blueAccent,
                  margin: EdgeInsetsDirectional.zero,
                  elevation: 8,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          "Olá, Fulano",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Bem-vindo de volta",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "R\$ 3.000,00",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "Saldo atual",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Card(
                elevation: 8,
                child: Container(
                  height: deviceSizeHeight * 0.13,
                  width: deviceSizeWidth * 0.28,
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
                  height: deviceSizeHeight * 0.13,
                  width: deviceSizeWidth * 0.28,
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
                  height: deviceSizeHeight * 0.13,
                  width: deviceSizeWidth * 0.28,
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
          Container(
            padding: const EdgeInsetsDirectional.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Últimas transações",
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: "Times New Roman",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
