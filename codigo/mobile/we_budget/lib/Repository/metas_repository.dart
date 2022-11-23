import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/metas.dart';
import '../exceptions/http_exception.dart';
import '../models/store.dart';
import '../utils/db_util.dart';
import 'package:http/http.dart' as http;

class RepositoryMetas with ChangeNotifier {
  List<MetasModel> _itemsMeta = [];

  insertMetas(MetasModel meta) async {
    Database db = await DBHelper.instance.database;

    Map<String, dynamic> row = {
      DBHelper.idMeta: meta.idMeta.toString(),
      DBHelper.idCategoria: meta.idCategoria.toString(),
      DBHelper.dataMeta: meta.dataMeta.toString(),
      DBHelper.valorMeta: meta.valorMeta.toString(),
      DBHelper.valorAtual: meta.valorAtual.toString(),
      DBHelper.recorrente: meta.recorrente.toString(),
    };
    await db.insert(DBHelper.tableMetas, row);
    _itemsMeta.add(meta);
    notifyListeners();
  }

  Future<List<MetasModel>> selectMetas() async {
    Database db = await DBHelper.instance.database;
    List<Map> metas = await db.rawQuery("SELECT * FROM ${DBHelper.tableMetas}");

    if (metas.isEmpty) {
      await _carregaTabela();
    }
    List<MetasModel> retorno = [];
    metas = await db.rawQuery("SELECT * FROM ${DBHelper.tableMetas}");

    for (var meta in metas) {
      retorno.add(
        MetasModel(
          idMeta: meta[DBHelper.idMeta],
          idCategoria: meta[DBHelper.idCategoria],
          dataMeta: meta[DBHelper.dataMeta],
          valorMeta: meta[DBHelper.valorMeta],
          valorAtual: meta[DBHelper.valorAtual],
          recorrente: meta[DBHelper.recorrente] == "false" ? false : true,
        ),
      );
    }

    _itemsMeta = retorno;
    notifyListeners();
    return retorno;
  }

  Future<void> _carregaTabela() async {
    // MetasModel meta1 = MetasModel(
    //   idCategoria: "15",
    //   idMeta: "1",
    //   dataMeta: "2022-11-18",
    //   valorMeta: 500,
    //   valorAtual: 0,
    //   recorrente: true,
    // );

    // await insertMetas(meta1);
  }

  Future<void> loadMetasRepository() async {
    Database db = await DBHelper.instance.database;
    List<Map> dataList =
        await db.rawQuery("SELECT * FROM ${DBHelper.tableMetas}");
    _itemsMeta = dataList
        .map(
          (item) => MetasModel(
            idCategoria: item['idCategoria'],
            idMeta: item['idMeta'],
            dataMeta: item['dataMeta'],
            valorMeta: item['valorMeta'] as double,
            valorAtual: item['valorAtual'] as double,
            recorrente: item['recorrente'] == "false" ? false : true,
          ),
        )
        .toList();

    notifyListeners();
  }

  Future<void> loadMetasRepository2(String filterDate) async {
    Database db = await DBHelper.instance.database;
    List<Map> dataList =
        await db.rawQuery("SELECT * FROM ${DBHelper.tableMetas}");
    _itemsMeta = dataList
        .map(
          (item) => MetasModel(
            idCategoria: item['idCategoria'],
            idMeta: item['idMeta'],
            dataMeta: item['dataMeta'],
            valorMeta: item['valorMeta'],
            valorAtual: item['valorAtual'],
            recorrente: item['recorrente'],
          ),
        )
        .toList();

    _itemsMeta =
        _itemsMeta.where((element) => element.dataMeta == filterDate).toList();
    notifyListeners();
  }

  Future<void> saveMetaSql(Map<String, dynamic> metasData) async {
    bool hasId = metasData['IdMeta'] != null;
    bool hasVarlorAtual = metasData['valorAtual'] != null;
    print("Id....$hasId");
    final metas = MetasModel(
      idMeta: hasId ? metasData['IdMeta'].toString() : "",
      idCategoria: metasData['CategoryId'].toString(),
      dataMeta: metasData['budgetDate'].toString(),
      valorMeta: metasData['budgetValue'],
      valorAtual: hasVarlorAtual ? metasData['valorAtual'] : 0.00,
      recorrente: metasData['active'],
    );

    if (hasId) {
      print("Entrou update");
      await updateMetaSql(metas);
    } else {
      print("Entrou create");
      print(metas);
      await createMetaSql(metas);
    }
  }

  int get itemsCount {
    return _itemsMeta.length;
  }

  void removeMetaSqflite(String metaId) async {
    selectMetas();
    Database db = await DBHelper.instance.database;

    await db.delete(
      DBHelper.tableMetas,
      where: "idMeta = ?",
      whereArgs: [metaId],
    );

    int index = _itemsMeta.indexWhere((p) => p.idMeta == metaId.toString());
    final meta = _itemsMeta[index];
    _itemsMeta.remove(meta);
    notifyListeners();
  }

  void updateMetaSqflite(MetasModel meta) async {
    loadMetasRepository();

    Database db = await DBHelper.instance.database;

    Map<String, String> row = {
      DBHelper.idCategoria: meta.idCategoria.toString(),
      DBHelper.dataMeta: meta.dataMeta.toString(),
      DBHelper.valorMeta: meta.valorMeta.toString(),
      DBHelper.valorAtual: meta.valorAtual.toString(),
      DBHelper.recorrente: meta.recorrente.toString(),
    };
    await db.update(
      DBHelper.tableMetas,
      row,
      where: "idMeta = ?",
      whereArgs: [meta.idMeta],
    );

    int index = _itemsMeta.indexWhere((p) => p.idMeta == meta.idMeta);

    if (index >= 0) {
      _itemsMeta[index] = meta;
      notifyListeners();
    }
  }

  MetasModel itemByIndex(int index) {
    return _itemsMeta[index];
  }

  List<MetasModel> getAll() {
    return _itemsMeta;
  }

  Future<void> createMetaSql(MetasModel meta) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'];
    String userId = userData['userId'];

    print("entrei Nataniel $meta");
    const url = 'https://webudgetpuc.azurewebsites.net/api/Budget/Add';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      body: jsonEncode(
        {
          'budgetValue': meta.valorMeta,
          'budgetDate': meta.dataMeta,
          'active': meta.recorrente,
          'categoryId': meta.idCategoria,
          'UserId': userId
        },
      ),
    );

    print("Entrou Nataniel 2");
    print("Entrei Nataniel 3: ${response.body}");
    final body = jsonDecode(response.body);
    // if (body['sucesso'] != true) {
    //   throw AuthException(body['erros'].toString());
    // }
  }

  Future<void> updateMetaSql(MetasModel meta) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'];
    String userId = userData['userId'];

    const url = 'https://webudgetpuc.azurewebsites.net/api/Budget';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      body: jsonEncode(
        {
          'id': int.parse(meta.idMeta),
          'budgetValue': meta.valorMeta,
          'budgetDate': meta.dataMeta,
          'active': meta.recorrente,
          'categoryId': meta.idCategoria,
          'UserId': userId
        },
      ),
    );
  }

  Future<void> removeMetaSql(String idMeta) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'];
    final url = 'https://webudgetpuc.azurewebsites.net/api/Budget/$idMeta';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("Remove Meta Nataniel ------ $idMeta");
    if (response.statusCode >= 400) {
      throw HttpException(
        msg: 'Não foi possível excluir o produto.',
        statusCode: response.statusCode,
      );
    }
  }

  void saveMetaSqflite(Map<String, dynamic> object, String operacao) {
    final meta = MetasModel(
      idCategoria: object['CategoryId'].toString(),
      idMeta: object['Id'].toString(),
      dataMeta: object['BudgetDate'].toString(),
      valorMeta: object['BudgetValue'],
      valorAtual: object['BudgetValueUsed'],
      recorrente: object['Active'],
    );

    if (operacao == "Create") {
      insertMetas(meta);
    } else if (operacao == "Update") {
      updateMetaSqflite(meta);
    } else if (operacao == "Delete") {
      removeMetaSqflite(meta.idMeta);
    } else {
      print("Operação não encontrada");
    }
  }
}
