import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:we_budget/pages/first_page.dart';
import 'package:we_budget/pages/lista_transacoes.dart';
import 'package:we_budget/pages/registrar_valores.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela inicial"),
      ),
      bottomNavigationBar: CurvedNavBar(
        actionButton: CurvedActionBar(
            onTab: (value) {
              /// perform action here
            },
            activeIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: const Icon(
                Icons.circle,
                size: 50,
                color: Colors.blueAccent,
              ),
            ),
            inActiveIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.circle,
                size: 50,
                color: Colors.blueAccent,
              ),
            ),
            text: "Início"),
        activeColor: Colors.white,
        navBarBackgroundColor: const Color.fromARGB(255, 7, 67, 117),
        inActiveColor: Colors.white,
        appBarItems: [
          FABBottomAppBarItem(
              activeIcon: const Icon(
                Icons.home,
                color: Colors.yellow,
              ),
              inActiveIcon: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              text: 'Nova Transação'),
          FABBottomAppBarItem(
              activeIcon: const Icon(
                Icons.wallet_giftcard,
                color: Colors.yellow,
              ),
              inActiveIcon: const Icon(
                Icons.wallet_giftcard,
                color: Colors.white,
              ),
              text: 'Lista Transações'),
        ],
        bodyItems: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const RegistrarValores(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const ListaTransacoes(),
          )
        ],
        actionBarView: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const FirstPage(),
        ),
      ),
    );
  }
}
