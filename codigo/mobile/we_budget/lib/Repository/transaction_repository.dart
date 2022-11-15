import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/transactions.dart';
import '../exceptions/auth_exception.dart';
import '../models/store.dart';
import '../utils/db_util_novo.dart';
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

  void removeTransaction(String transactionId) {
    _items.remove(transactionId);
    return notifyListeners();
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

  Future<void> postTransaction(Map<String, Object> transaction) async {
    print("Entrou post transaction...");
    print("Entrou no provider....$_token");
    print(transaction);
    Map<String, dynamic> userData = await Store.getMap('userData');
    print(userData);
    // String token = userData['token'];
    // print("Token.......$token");

    // String userId = userData['userId'];
    // print("Token.......$userId");

    const url = 'http://localhost:5001/api/Transaction/Add';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJXZUJ1ZGdldCIsImp0aSI6ImE1MTlhOWU3LTQ2NjYtNDIwMS1hN2E1LTdkNTI2NmRiYTFjNyIsImlkVXN1YXJpbyI6Ijg1N2YwZDMzLWQyNDQtNDllNS1iNjFkLTQ4ZjlmODU2MzQ2MyIsImV4cCI6MTY2ODYwOTc0MCwiaXNzIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIiwiYXVkIjoiVGVzdGUuU2VjdXJpcnkuQmVhcmVyIn0.QnRvCyuqPvMm2iikLEe7ke17bBt596xaLJALLCeUt6M',
      },
      body: jsonEncode(
        {
          'Category': transaction['Category'],
          'TransactionType': transaction['TransactionType'],
          'Description': transaction['Description'],
          'TransactionDate': transaction['TransactionDate'],
          'PaymentValue': transaction['PaymentValue'],
          'PaymentType': transaction['PaymentType'],
          'Longitude': transaction['Longitude'],
          'Latitude': transaction['Latitude'],
          'Address': transaction['Address'],
          'userId': "857f0d33-d244-49e5-b61d-48f9f8563463",
        },
      ),
    );

    final body = jsonDecode(response.body);
    print("Response....");
    print(body);
    if (body['sucesso'] != true) {
      throw AuthException(body['erros'].toString());
    } else {
      notifyListeners();
    }
  }
}
