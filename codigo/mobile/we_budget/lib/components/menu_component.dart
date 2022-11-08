import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../pages/list_transactions_page.dart';
import '../pages/metas_page.dart';
import '../pages/welcome_page.dart';
import '../utils/app_routes.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavBar(
      actionButton: CurvedActionBar(
        onTab: (value) {
          /// perform action here
        },
        activeIcon: Container(
          padding: const EdgeInsets.all(0),
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(
            Icons.circle,
            size: 50,
            color: const Color(0xFF5B4BF8),
          ),
        ),
        inActiveIcon: Container(
          padding: const EdgeInsets.all(0),
          decoration: const BoxDecoration(
            color: const Color(0xFF5B4BF8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.circle),
            iconSize: 40,
            color: const Color(0xFF5B4BF8),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.formTransaction);
            },
          ),
        ),
      ),
      activeColor: Colors.white,
      navBarBackgroundColor: const Color(0xFF1B1C30),
      inActiveColor: Colors.white,
      appBarItems: [
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.home,
              color: const Color(0xFF923DF8),
            ),
            inActiveIcon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            text: 'Tela Inicial'),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.wallet_giftcard,
              color: const Color(0xFF923DF8),
            ),
            inActiveIcon: const Icon(
              Icons.money_off,
              color: Colors.white,
            ),
            text: 'Metas'),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.wallet_giftcard,
              color: const Color(0xFF923DF8),
            ),
            inActiveIcon: const Icon(
              Icons.list,
              color: Colors.white,
            ),
            text: 'Lista'),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.wallet_giftcard,
              color: const Color(0xFF923DF8),
            ),
            inActiveIcon: const Icon(
              Icons.wallet_giftcard,
              color: Colors.white,
            ),
            text: 'Gráfico'),
      ],
      bodyItems: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const WelcomePage(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const MetasPage(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const ListTransactionsPage(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: Text("Em desenvolvimento"),
          ),
        ),
      ],
      actionBarView: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const WelcomePage(),
      ),
    );
  }
}
