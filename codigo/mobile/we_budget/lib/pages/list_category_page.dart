import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/Repository/transaction_repository.dart';
import 'package:we_budget/utils/app_routes.dart';

class ListCategoryPage extends StatefulWidget {
  const ListCategoryPage({super.key});
  @override
  State<ListCategoryPage> createState() => _ListTransactionsPageState();
}

class _ListTransactionsPageState extends State<ListCategoryPage> {
  String? _categorySelect;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categoria"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.createCategory);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<RepositoryCategory>(context, listen: false)
            .loadCategoryRepository(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Consumer<RepositoryCategory>(
                child: const Center(
                  child: Text('Nenhum dado cadastrado!'),
                ),
                builder: (ctx, trasactionList, ch) => trasactionList
                            .itemsCount ==
                        0
                    ? ch!
                    : ListView.builder(
                        itemCount: trasactionList.itemsCount,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: Icon(
                            IconData(
                                int.parse(trasactionList
                                        .itemByIndex(i)
                                        .codeCategoria)
                                    .toInt(),
                                fontFamily: "MaterialIcons"),
                          ),
                          title:
                              Text(trasactionList.itemByIndex(i).nameCategoria),
                          onTap: () {
                            setState(
                              () {
                                _categorySelect =
                                    trasactionList.itemByIndex(i).nameCategoria;
                              },
                            );
                            Navigator.pushNamed(
                                context, AppRoutes.formTransaction,
                                arguments: _categorySelect);
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}