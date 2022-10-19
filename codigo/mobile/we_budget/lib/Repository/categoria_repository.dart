import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/categoria_model.dart';

import '../utils/db_util_novo.dart';

class RepositoryCategoria {
  insertCategoria(CategoriaModel categoria) async {
    Database db = await DBHelper.instance.database;

    Map<String, String> row = {
      DBHelper.id: categoria.id.toString(),
      DBHelper.codeCategoria: categoria.codeCategoria.toString(),
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
        ),
      );
    }

    print("Length categoria");
    print(retorno.length);
    print(retorno);
    return retorno;
  }

  Future<void> _carregaTabela() async {
    print("Entrou carrega tabela");
    CategoriaModel categoria1 =
        CategoriaModel(id: "1", codeCategoria: "Viagem");
    CategoriaModel categoria2 = CategoriaModel(id: "2", codeCategoria: "Carro");
    CategoriaModel categoria3 =
        CategoriaModel(id: "3", codeCategoria: "Alimento");

    await insertCategoria(categoria1);
    await insertCategoria(categoria2);
    await insertCategoria(categoria3);
  }
}
