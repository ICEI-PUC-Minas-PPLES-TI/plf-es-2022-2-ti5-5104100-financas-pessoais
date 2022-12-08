import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:we_budget/components/pie_chart_widget.dart';
import 'package:we_budget/components/pie_chart_widget2.dart';
import '../pages/graficos_page.dart';
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
            Icons.monetization_on_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
        inActiveIcon: Container(
          padding: const EdgeInsets.all(0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            icon: const Icon(Icons.monetization_on_rounded),
            iconSize: 70,
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
              color: Color(0xFF923DF8),
            ),
            inActiveIcon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            text: 'Tela Inicial'),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.checklist_rounded,
              color: Color(0xFF923DF8),
            ),
            inActiveIcon: const Icon(
              Icons.checklist_rounded,
              color: Colors.white,
            ),
            text: 'Metas'),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.list,
              color: Color(0xFF923DF8),
            ),
            inActiveIcon: const Icon(
              Icons.list,
              color: Colors.white,
            ),
            text: 'Lista'),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.assessment_outlined,
              color: Color(0xFF923DF8),
            ),
            inActiveIcon: const Icon(
              Icons.assessment_outlined,
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
            height: MediaQuery.of(context).size.height, child: Graficos_page())
      ],
      actionBarView: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const WelcomePage(),
      ),
    );
  }
}

class SectorRow2 extends StatelessWidget {
  const SectorRow2(this.sector, {Key? key}) : super(key: key);
  final Sector2 sector;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: CircleAvatar(
            backgroundColor: sector.color,
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 10.0)),
        Text('R\$' + sector.value.toString() + '0'),
        const Spacer(),
        Text(sector.title),
      ],
    );
  }
}

class SectorRow extends StatelessWidget {
  const SectorRow(this.sector, {Key? key}) : super(key: key);
  final Sector sector;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: CircleAvatar(
            backgroundColor: sector.color,
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 10.0)),
        Text('R\$' + sector.value.toString() + '0'),
        const Spacer(),
        Text(sector.title),
      ],
    );
  }
}
