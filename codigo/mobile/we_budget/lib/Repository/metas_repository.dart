import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/Metas.dart';

import '../models/metas.dart';
import '../utils/db_util_novo.dart';

class RepositoryMetas with ChangeNotifier {
  List<MetasModel> _items = [];

  insertMetas(MetasModel Meta) async {
    Database db = await DBHelper.instance.database;

    Map<String, dynamic> row = {
      DBHelper.idMeta: Meta.idMeta.toString(),
      DBHelper.idCategoria: Meta.idCategoria.toString(),
      DBHelper.idUser: Meta.idUser.toString(),
      DBHelper.dataMeta: Meta.dataMeta.toString(),
      DBHelper.valorMeta: Meta.valorMeta.toString(),
      DBHelper.valorAtual: Meta.valorAtual.toString(),
      DBHelper.recorrente: Meta.recorrente.toString(),
    };
    await db.insert(DBHelper.tableMetas, row);
    notifyListeners();
  }

  Future<List<MetasModel>> selectMetas() async {
    Database db = await DBHelper.instance.database;

    List<Map> Metas = await db.rawQuery("SELECT * FROM ${DBHelper.tableMetas}");

    List<MetasModel> retorno = [];
    Metas = await db.rawQuery("SELECT * FROM ${DBHelper.tableMetas}");

    for (var Meta in Metas) {
      retorno.add(
        MetasModel(
          idMeta: Meta[DBHelper.idMeta],
          idCategoria: Meta[DBHelper.idCategoria],
          idUser: Meta[DBHelper.idUser],
          dataMeta: Meta[DBHelper.dataMeta],
          valorMeta: Meta[DBHelper.valorMeta],
          valorAtual: Meta[DBHelper.valorAtual],
          recorrente: Meta[DBHelper.recorrente],
        ),
      );
    }

    print("Length Metas");
    print(retorno.length);
    print(retorno);
    notifyListeners();
    return retorno;
  }

  Future<void> loadMetasRepository() async {
    Database db = await DBHelper.instance.database;
    List<Map> dataList =
        await db.rawQuery("SELECT * FROM ${DBHelper.tableMetas}");
    _items = dataList
        .map(
          (item) => MetasModel(
            idCategoria: item['idCategoria'],
            idMeta: item['idMeta'],
            idUser: item['idUser'],
            dataMeta: item['dataMeta'],
            valorMeta: item['valorMeta'],
            valorAtual: item['valorAtual'],
            recorrente: item['recorrente'],
          ),
        )
        .toList();

    notifyListeners();
  }

  Future<void> loadMetasRepository2(String filterDate) async {
    print("data: $filterDate");
    Database db = await DBHelper.instance.database;
    List<Map> dataList =
        await db.rawQuery("SELECT * FROM ${DBHelper.tableMetas}");
    _items = dataList
        .map(
          (item) => MetasModel(
            idCategoria: item['idCategoria'],
            idMeta: item['idMeta'],
            idUser: item['idUser'],
            dataMeta: item['dataMeta'],
            valorMeta: item['valorMeta'],
            valorAtual: item['valorAtual'],
            recorrente: item['recorrente'],
          ),
        )
        .toList();

    _items = _items.where((element) => element.dataMeta == filterDate).toList();
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  void removeMetas(String MetasId) {
    _items.remove(MetasId);
    return notifyListeners();
  }

  MetasModel itemByIndex(int index) {
    return _items[index];
  }

  List<MetasModel> getAll() {
    return _items;
  }
}
