import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/categoria_model.dart';
import 'package:http/http.dart' as http;
import '../exceptions/auth_exception.dart';
import '../exceptions/http_exception.dart';
import '../models/store.dart';
import '../utils/db_util.dart';

class RepositoryCategory with ChangeNotifier {
  List<CategoriaModel> _categories = [];
  String _token;

  RepositoryCategory(this._token);

  insertCategoria(CategoriaModel categoria) async {
    Database db = await DBHelper.instance.database;

    Map<String, String> row = {
      DBHelper.id: categoria.id.toString(),
      DBHelper.codeCategoria: categoria.codeCategoria.toString(),
      DBHelper.nameCategoria: categoria.nameCategoria.toString(),
    };
    await db.insert(DBHelper.tableCategoria, row);
    _categories.add(categoria);
    notifyListeners();
  }

  void removeCategorySqflite(int transactionId) async {
    Database db = await DBHelper.instance.database;

    await db.delete(
      DBHelper.tableCategoria,
      where: "id = ?",
      whereArgs: [transactionId],
    );

    int index = _categories.indexWhere((p) => p.id == transactionId.toString());
    final trasaction = _categories[index];
    _categories.remove(trasaction);
    notifyListeners();
  }

  void updateCategorySqflite(CategoriaModel category) async {
    Database db = await DBHelper.instance.database;

    Map<String, String> row = {
      DBHelper.id: category.id.toString(),
      DBHelper.codeCategoria: category.codeCategoria.toString(),
      DBHelper.nameCategoria: category.nameCategoria.toString(),
    };
    await db.update(
      DBHelper.tableCategoria,
      row,
      where: "id = ?",
      whereArgs: [category.id],
    );

    int index = _categories.indexWhere((p) => p.id == category.id);
    if (index >= 0) {
      _categories[index] = category;
      notifyListeners();
    }
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
    // CategoriaModel categoria1 = CategoriaModel(
    //   id: "100",
    //   codeCategoria: "57664",
    //   nameCategoria: "Viagem",
    // );
    // CategoriaModel categoria2 = CategoriaModel(
    //   id: "200",
    //   codeCategoria: "57864",
    //   nameCategoria: "Carro",
    // );
    // CategoriaModel categoria3 = CategoriaModel(
    //   id: "300",
    //   codeCategoria: "61468",
    //   nameCategoria: "Alimento",
    // );

    // await insertCategoria(categoria1);
    // await insertCategoria(categoria2);
    // await insertCategoria(categoria3);
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

  List<CategoriaModel> listCategories() {
    return _categories;
  }

  Future<void> createCategorySql(Map<String, dynamic> category) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'];
    String userId = userData['userId'];

    const url = 'https://webudgetpuc.azurewebsites.net/api/Category/Add';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      body: jsonEncode(
        {
          "description": category['nameCreateCategory'],
          "iconCode": category['codeCreateCategory'],
          "userId": userId
        },
      ),
    );

    final body = jsonDecode(response.body);
    // if (body['sucesso'] != true) {
    //   throw AuthException(body['erros'].toString());
    // }
  }

  Future<void> updateCategorySql(CategoriaModel category) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'];
    String userId = userData['userId'];

    const url = 'https://webudgetpuc.azurewebsites.net/api/Category';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      body: jsonEncode(
        {
          "id": category.id,
          "description": category.nameCategoria,
          "iconCode": category.codeCategoria,
          "userId": userId
        },
      ),
    );
  }

  Future<void> removeCategorySql(CategoriaModel category) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'];

    final id = category.id;
    final url = 'https://webudgetpuc.azurewebsites.net/api/Category/$id';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 400) {
      throw HttpException(
        msg: 'Não foi possível excluir o produto.',
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> saveTransactionSql(Map<String, dynamic> categoryData) async {
    bool hasId = categoryData['Id'] != null;

    final transaction = CategoriaModel(
      id: hasId ? categoryData['Id'] as String : "",
      nameCategoria: categoryData['nameCreateCategory'] as String,
      codeCategoria: categoryData['codeCreateCategory'].toString(),
    );

    if (hasId) {
      await updateCategorySql(transaction);
    } else {
      await createCategorySql(categoryData);
    }
  }

  void saveCategorySqflite(Map<String, dynamic> object, String operacao) {
    final category = CategoriaModel(
      id: object['Id'].toString(),
      codeCategoria: object['IconCode'].toString(),
      nameCategoria: object['Description'].toString(),
    );

    if (operacao == "Create") {
      insertCategoria(category);
    } else if (operacao == "Update") {
      updateCategorySqflite(category);
    } else if (operacao == "Delete") {
      removeCategorySqflite(int.parse(category.id));
    } else {
      print("Operação não encontrada");
    }
  }

  int codeCategory(String id) {
    selectCategoria();
    int index = _categories.indexWhere((element) => element.id == id);
    int category = 57522;

    if (index == -1) {
      return category;
    } else {
      category = int.parse(_categories[index].codeCategoria);
      return category;
    }
  }

  String selectNameCategoria(String id) {
    selectCategoria();

    int index = _categories.indexWhere((element) => element.id == id);
    if (index == -1) {
      index = 0;
    }

    String nameCategory = _categories[index].nameCategoria;

    return nameCategory;
  }
}
