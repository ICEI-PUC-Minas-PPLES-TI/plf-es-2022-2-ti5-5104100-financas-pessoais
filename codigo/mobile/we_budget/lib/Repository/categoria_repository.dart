import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/categoria_model.dart';

import '../utils/db_util_novo.dart';

class RepositoryCategory with ChangeNotifier {
  List<CategoriaModel> _categories = [];
  insertCategoria(CategoriaModel categoria) async {
    Database db = await DBHelper.instance.database;

    Map<String, String> row = {
      DBHelper.id: categoria.id.toString(),
      DBHelper.codeCategoria: categoria.codeCategoria.toString(),
      DBHelper.nameCategoria: categoria.nameCategoria.toString(),
    };
    await db.insert(DBHelper.tableCategoria, row);
  }

  Future<List<CategoriaModel>> selectCategoria() async {
    Database db = await DBHelper.instance.database;
    List<Map> categorias =
        await db.rawQuery("SELECT * FROM ${DBHelper.tableCategoria}");
    if (categorias.isEmpty) {
      await _carregaTabela();
    }
    List<CategoriaModel> retorno = [];
    categorias = await db.rawQuery("SELECT * FROM ${DBHelper.tableCategoria}");

    for (var categoria in categorias) {
      retorno.add(
        CategoriaModel(
          id: categoria[DBHelper.id],
          codeCategoria: categoria[DBHelper.codeCategoria],
          nameCategoria: categoria[DBHelper.nameCategoria],
        ),
      );
    }
    _categories = retorno;
    return retorno;
  }

  Future<void> _carregaTabela() async {
    CategoriaModel categoria1 = CategoriaModel(
        id: "1", codeCategoria: "57664", nameCategoria: "Viagem");
    CategoriaModel categoria2 =
        CategoriaModel(id: "2", codeCategoria: "57864", nameCategoria: "Carro");
    CategoriaModel categoria3 = CategoriaModel(
        id: "3", codeCategoria: "61468", nameCategoria: "Alimento");

    await insertCategoria(categoria1);
    await insertCategoria(categoria2);
    await insertCategoria(categoria3);
  }

  Future<void> loadCategoryRepository() async {
    Database db = await DBHelper.instance.database;
    List<Map> dataList =
        await db.rawQuery("SELECT * FROM ${DBHelper.tableCategoria}");
    _categories = dataList
        .map(
          (item) => CategoriaModel(
            id: item['id'],
            codeCategoria: item['codeCategoria'],
            nameCategoria: item['nameCategoria'],
          ),
        )
        .toList();
    notifyListeners();
  }

  int get itemsCount {
    return _categories.length;
  }

  CategoriaModel itemByIndex(int index) {
    return _categories[index];
  }

  Future<List<CategoriaModel>> get getCategories async {
    return _categories;
  }
}
