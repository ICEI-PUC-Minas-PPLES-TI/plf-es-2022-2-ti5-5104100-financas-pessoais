import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/categoria_model.dart';
import 'package:http/http.dart' as http;
import '../exceptions/auth_exception.dart';
import '../exceptions/http_exception.dart';
import '../models/store.dart';
import '../utils/db_util_novo.dart';

class RepositoryCategory with ChangeNotifier {
  List<CategoriaModel> _categories = [];
  String _token;
  RepositoryCategory(this._token);
  insertCategoria(CategoriaModel categoria) async {
    print("Category recebida.....$categoria");
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

  Future<void> postCategory(Map<String, dynamic> category) async {
    print("Entrou post");
    Map<String, dynamic> userData = await Store.getMap('userData');
    print(userData);
    String token = userData['token'];
    String userId = userData['userId'];
    const url = 'http://localhost:5001/api/Category/Add';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
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
    print("Response....$body");
    notifyListeners();
  }

  Future<void> removeProduct(CategoriaModel category) async {
    int index = _categories.indexWhere((p) => p.id == category.id);

    if (index >= 0) {
      final product = _categories[index];
      _categories.remove(product);
      notifyListeners();
      const url = 'http://localhost:5001/api/Category/Add';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode >= 400) {
        _categories.insert(index, product);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
