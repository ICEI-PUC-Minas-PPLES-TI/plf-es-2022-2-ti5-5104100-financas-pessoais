import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/components/pie_chart_widget.dart';
import 'package:we_budget/components/price_point.dart';
import 'package:we_budget/components/sector.dart';

import '../Repository/transaction_repository.dart';
import '../models/transactions.dart';
import '../pages/list_transactions_page.dart';
import '../pages/metas_page.dart';
import '../pages/welcome_page.dart';
import '../utils/app_routes.dart';
import 'bar_chart_widget.dart';
import 'line_chart_widget.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RepositoryTransaction transaction = Provider.of(context);
    List<TransactionModel> listaTrasaction = transaction.getAll();
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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, top: 30.0, right: 30.0, bottom: 100.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Despesas por categoria',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    PieChartWidget(listaTrasaction),
                    Column(
                        // children: listaTrasaction
                        //     .map<Widget>((sector) => SectorRow(sector))
                        //     .toList(),
                        ),
                    const Text(
                      'Receitas por mês',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    LineChartWidget(pricePoints),
                    const Padding(padding: EdgeInsets.all(20)),
                    const Text(
                      'Despesas por mês',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    BarChartWidget(points: pricePoints),
                  ],
                ),
              ),
            )),
      ],
      actionBarView: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const WelcomePage(),
      ),
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
        const Spacer(),
        Text(sector.title),
      ],
    );
  }
}
