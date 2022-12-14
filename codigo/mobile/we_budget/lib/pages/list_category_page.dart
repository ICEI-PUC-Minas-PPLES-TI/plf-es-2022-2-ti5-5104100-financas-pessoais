import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/utils/app_routes.dart';

import '../utils/shared_preference.dart';

class ListCategoryPage extends StatefulWidget {
  const ListCategoryPage({super.key});
  @override
  State<ListCategoryPage> createState() => _ListTransactionsPageState();
}

class _ListTransactionsPageState extends State<ListCategoryPage> {
  String? _categorySelect;
  @override
  Widget build(BuildContext context) {
    String qualPaginaChamou =
        ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categoria"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF923DF8),
                Color(0xFF4C94F8),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
        ),
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
                        itemBuilder: (ctx, i) => Dismissible(
                          background: Container(
                            color: const Color(0xFF45CFF1),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  Text(
                                    " Editar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            setState(() {
                              Map<String, dynamic> arguments = {
                                'page': 'listCategory',
                                'itemByIndex': trasactionList.itemByIndex(i),
                              };
                              Navigator.of(context).pushNamed(
                                AppRoutes.createCategory,
                                arguments: arguments,
                              );
                            });
                          },
                          key: ValueKey(
                              trasactionList.itemByIndex(i).codeCategoria),
                          child: ListTile(
                              leading: Icon(
                                IconData(
                                    int.parse(trasactionList
                                            .itemByIndex(i)
                                            .codeCategoria)
                                        .toInt(),
                                    fontFamily: "MaterialIcons"),
                              ),
                              title: Text(
                                  trasactionList.itemByIndex(i).nameCategoria),
                              onTap: () {
                                setState(
                                  () {
                                    _categorySelect =
                                        trasactionList.itemByIndex(i).id;
                                  },
                                );
                                // Map<String, dynamic> arguments = {
                                //   'page': 'category',
                                //   'itemByIndex': _categorySelect,
                                // };
                                Store.saveMap(
                                  'category',
                                  {
                                    'category': _categorySelect,
                                  },
                                );
                                Navigator.of(context).pop();
                              }),
                        ),
                      ),
              ),
      ),
    );
  }
}
