import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/transactions.dart';

import '../utils/db_util_novo.dart';

class RepositoryTransaction with ChangeNotifier {
  List<TransactionModel> _items = [];

  insertTransacao(TransactionModel transaction) async {
    Database db = await DBHelper.instance.database;

    Map<String, dynamic> row = {
      DBHelper.idTransaction: transaction.idTransaction.toString(),
      DBHelper.name: transaction.name.toString(),
      DBHelper.categoria: transaction.categoria.toString(),
      DBHelper.data: transaction.data.toString(),
      DBHelper.valor: transaction.valor.toString(),
      DBHelper.formaPagamento: transaction.formaPagamento.toString(),
      DBHelper.tipoTransacao: transaction.tipoTransacao.toString(),
      DBHelper.latitude: transaction.location.latitude.toString(),
      DBHelper.longitude: transaction.location.longitude.toString(),
      DBHelper.address: transaction.location.address.toString(),
    };
    await db.insert(DBHelper.tableTransaction, row);
    notifyListeners();
  }

  Future<List<TransactionModel>> selectTransaction() async {
    Database db = await DBHelper.instance.database;

    List<Map> transaction =
        await db.rawQuery("SELECT * FROM ${DBHelper.tableTransaction}");

    if (transaction.isEmpty) {
      await _carregaTabela();
    }
    List<TransactionModel> retorno = [];
    transaction =
        await db.rawQuery("SELECT * FROM ${DBHelper.tableTransaction}");

    for (var transaction in transaction) {
      retorno.add(
        TransactionModel(
          idTransaction: transaction[DBHelper.idTransaction],
          name: transaction[DBHelper.name],
          categoria: transaction[DBHelper.categoria],
          data: transaction[DBHelper.data],
          valor: transaction[DBHelper.valor],
          formaPagamento: transaction[DBHelper.formaPagamento],
          tipoTransacao: transaction[DBHelper.tipoTransacao],
          location: TransactionLocation(
            latitude: transaction[DBHelper.latitude],
            longitude: transaction[DBHelper.longitude],
            address: transaction[DBHelper.address],
          ),
        ),
      );
    }

    print("Length transaction");
    print(retorno.length);
    print(retorno);
    notifyListeners();
    return retorno;
  }

  Future<void> loadTransactionRepository() async {
    print("Entrou load....");
    Database db = await DBHelper.instance.database;
    List<Map> dataList =
        await db.rawQuery("SELECT * FROM ${DBHelper.tableTransaction}");
    _items = dataList
        .map(
          (item) => TransactionModel(
            idTransaction: item['idTransaction'],
            name: item['name'],
            categoria: item['categoria'],
            data: item['data'],
            valor: item['valor'],
            formaPagamento: item['formaPagamento'],
            tipoTransacao: item['tipoTransacao'],
            location: TransactionLocation(
              latitude: item['latitude'],
              longitude: item['longitude'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  TransactionModel itemByIndex(int index) {
    return _items[index];
  }

  Future<void> _carregaTabela() async {
    TransactionModel transaction1 = TransactionModel(
      idTransaction: "1",
      name: "Café",
      categoria: "Alimentação",
      data: "2022-10-10",
      valor: 28,
      formaPagamento: "Dinheiro",
      tipoTransacao: "Despesa",
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua A",
      ),
    );

    TransactionModel transaction2 = TransactionModel(
      idTransaction: "2",
      name: "Jantar",
      categoria: "Alimentação",
      data: "2022-10-15",
      valor: 35,
      formaPagamento: "Dinheiro",
      tipoTransacao: "Despesa",
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua B",
      ),
    );

    await insertTransacao(transaction1);
    await insertTransacao(transaction2);
  }
}
