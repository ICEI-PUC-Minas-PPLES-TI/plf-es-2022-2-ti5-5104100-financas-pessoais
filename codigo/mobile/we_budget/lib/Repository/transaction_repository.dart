import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/transactions.dart';
import '../exceptions/auth_exception.dart';
import '../exceptions/http_exception.dart';
import '../models/store.dart';
import '../utils/db_util.dart';
import 'package:http/http.dart' as http;

class RepositoryTransaction with ChangeNotifier {
  String _token;
  RepositoryTransaction(this._token);
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
    _items.add(transaction);
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

    notifyListeners();
    return retorno;
  }

  Future<void> loadTransactionRepository() async {
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

  Future<void> loadTransactionRepository2(
      int typeTransaction, String filterDate) async {
    print("data: $filterDate");
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

    _items = _items
        .where((element) => element.tipoTransacao == typeTransaction)
        .toList();

    _items = _items
        .where((element) => element.data.substring(0, 7) == filterDate)
        .toList();
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  void removeTransactionSqflite(int transactionId) {
    int index =
        _items.indexWhere((p) => p.idTransaction == transactionId.toString());
    final trasaction = _items[index];
    _items.remove(trasaction);
    notifyListeners();
  }

  void updateTransactionSqflite(TransactionModel transaction) {
    int index =
        _items.indexWhere((p) => p.idTransaction == transaction.idTransaction);

    if (index >= 0) {
      _items[index] = transaction;
      notifyListeners();
    }
  }

  TransactionModel itemByIndex(int index) {
    return _items[index];
  }

  List<TransactionModel> getAll() {
    return _items;
  }

  Future<void> _carregaTabela() async {
    TransactionModel transaction1 = TransactionModel(
      idTransaction: "1",
      name: "Café",
      categoria: "Alimentação",
      data: "2021-10-10",
      valor: 28,
      formaPagamento: "Dinheiro",
      tipoTransacao: 0,
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
      tipoTransacao: 1,
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua B",
      ),
    );

    TransactionModel transaction4 = TransactionModel(
      idTransaction: "4",
      name: "Gasolina",
      categoria: "Carro",
      data: "2022-10-15",
      valor: 120,
      formaPagamento: "Dinheiro",
      tipoTransacao: 1,
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua B",
      ),
    );

    TransactionModel transaction5 = TransactionModel(
      idTransaction: "5",
      name: "Viagem - Búzios",
      categoria: "Viagem",
      data: "2022-10-15",
      valor: 500,
      formaPagamento: "Dinheiro",
      tipoTransacao: 1,
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua B",
      ),
    );

    TransactionModel transaction6 = TransactionModel(
      idTransaction: "6",
      name: "Venda - EcoSport",
      categoria: "Carro",
      data: "2022-10-15",
      valor: 15000,
      formaPagamento: "Dinheiro",
      tipoTransacao: 0,
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua B",
      ),
    );

    TransactionModel transaction7 = TransactionModel(
      idTransaction: "7",
      name: "Venda - Iphone X",
      categoria: "Carro",
      data: "2019-10-06",
      valor: 4000,
      formaPagamento: "Dinheiro",
      tipoTransacao: 0,
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua B",
      ),
    );

    TransactionModel transaction8 = TransactionModel(
      idTransaction: "8",
      name: "Compra - Iphone 12",
      categoria: "Carro",
      data: "2020-01-02",
      valor: 8000,
      formaPagamento: "Dinheiro",
      tipoTransacao: 1,
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua B",
      ),
    );

    TransactionModel transaction9 = TransactionModel(
      idTransaction: "9",
      name: "Compra - Passagens aéreas",
      categoria: "Viagem",
      data: "2019-06-06",
      valor: 3400.99,
      formaPagamento: "Dinheiro",
      tipoTransacao: 1,
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua B",
      ),
    );

    TransactionModel transaction10 = TransactionModel(
      idTransaction: "10",
      name: "Aniversário 15 anos Fernanda",
      categoria: "Viagem",
      data: "2018-06-06",
      valor: 2000.00,
      formaPagamento: "Dinheiro",
      tipoTransacao: 1,
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua B",
      ),
    );

    TransactionModel transaction11 = TransactionModel(
      idTransaction: "11",
      name: "Almoço em família Natal",
      categoria: "Alimentação",
      data: "2021-12-24",
      valor: 2000.00,
      formaPagamento: "Dinheiro",
      tipoTransacao: 1,
      location: const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
        address: "Rua B",
      ),
    );

    await insertTransacao(transaction1);
    await insertTransacao(transaction2);
    await insertTransacao(transaction4);
    await insertTransacao(transaction5);
    await insertTransacao(transaction6);
    await insertTransacao(transaction7);
    await insertTransacao(transaction8);
    await insertTransacao(transaction9);
    await insertTransacao(transaction10);
    await insertTransacao(transaction11);
  }

  Future<void> createTransactionSql(TransactionModel transaction) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'];
    String userId = userData['userId'];

    const url = 'https://webudgetpuc.azurewebsites.net/api/Transaction/Add';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      body: jsonEncode(
        {
          'Description': transaction.name,
          'PaymentValue': transaction.valor,
          'PaymentType': transaction.formaPagamento,
          'TransactionType': transaction.tipoTransacao,
          'TransactionDate': transaction.data,
          'Latitude': transaction.location.latitude,
          'Longitude': transaction.location.longitude,
          'Address': transaction.location.address,
          'CategoryId': int.parse(transaction.categoria),
          'UserId': userId
        },
      ),
    );

    print(response.statusCode);
    final body = jsonDecode(response.body);
    // if (body['sucesso'] != true) {
    //   throw AuthException(body['erros'].toString());
    // }
  }

  Future<void> saveTransactionSql(Map<String, Object> transactionData) async {
    bool hasId = transactionData['id'] != null;
    final transaction = TransactionModel(
      idTransaction: hasId ? transactionData['IdTransaction'] as String : "",
      name: transactionData['Description'] as String,
      categoria: transactionData['Category'] as String,
      data: transactionData['TransactionDate'] as String,
      valor: transactionData['PaymentValue'] as double,
      formaPagamento: transactionData['PaymentType'] as String,
      tipoTransacao: int.parse(transactionData['TransactionType'].toString()),
      location: TransactionLocation(
        latitude: double.parse(transactionData['Latitude'].toString()),
        longitude: double.parse(transactionData['Longitude'].toString()),
        address: transactionData['Address'] as String,
      ),
    );

    if (hasId) {
      print("Entrou update");
      // await updateTransactionSql(transaction);
    } else {
      print("Entrou create");
      await createTransactionSql(transaction);
    }
  }

  Future<void> updateTransactionSql(TransactionModel transaction) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'];
    String userId = userData['userId'];

    const url = 'https://webudgetpuc.azurewebsites.net/api/Transaction';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      body: jsonEncode(
        {
          'id': int.parse(transaction.idTransaction),
          'Description': transaction.name,
          'PaymentValue': transaction.valor,
          'PaymentType': transaction.formaPagamento,
          'TransactionType': transaction.tipoTransacao,
          'TransactionDate': transaction.data,
          'Latitude': transaction.location.latitude,
          'Longitude': transaction.location.longitude,
          'Address': transaction.location.address,
          'CategoryId': int.parse(transaction.categoria),
          'UserId': userId,
        },
      ),
    );

    print(response.statusCode);
  }

  Future<void> removeTrasactionSql(TransactionModel trasaction) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'];

    final id = trasaction.idTransaction;
    final url = 'https://webudgetpuc.azurewebsites.net/api/Transaction/$id';

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
    print(response.statusCode);
  }
}
