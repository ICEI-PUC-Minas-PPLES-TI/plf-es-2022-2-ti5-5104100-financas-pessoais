import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/transaction_repository.dart';

import '../components/card_main_page.dart';
import '../components/welcome_saldo.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
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
              width: double.infinity,
              height: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        WelcomeSaldo(
                          texto: "Olá Fulano",
                          size: 25,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        WelcomeSaldo(
                          texto: "Bem-vindo de volta",
                          size: 25,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        WelcomeSaldo(
                          texto: "R\$ 3.000,00",
                          size: 22,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        WelcomeSaldo(
                          texto: "Saldo atual",
                          size: 22,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: size * 0.70,
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CardMainPage(title: "Receita"),
                          CardMainPage(title: "Despesa"),
                          CardMainPage(title: "Balanço mês"),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsetsDirectional.only(top: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Últimas transações",
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 380),
              child: FutureBuilder(
                future:
                    Provider.of<RepositoryTransaction>(context, listen: false)
                        .loadTransactionRepository(),
                builder: (ctx, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : Consumer<RepositoryTransaction>(
                        child: const Center(
                          child: Text('Nenhum dado cadastrado!'),
                        ),
                        builder: (ctx, trasactionList, ch) => trasactionList
                                    .itemsCount ==
                                0
                            ? ch!
                            : ListView.builder(
                                itemCount: trasactionList.itemsCount > 3
                                    ? trasactionList.itemsCount
                                    : 2,
                                itemBuilder: (ctx, i) => ListTile(
                                  leading: const Icon(Icons.coffee),
                                  title:
                                      Text(trasactionList.itemByIndex(i).name),
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
                                        .toString(),
                                  ),
                                ),
                              ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
