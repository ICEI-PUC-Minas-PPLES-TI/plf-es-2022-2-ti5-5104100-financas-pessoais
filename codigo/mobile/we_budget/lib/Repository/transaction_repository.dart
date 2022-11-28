import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/transactions.dart';
import '../exceptions/http_exception.dart';
import '../models/store.dart';
import '../utils/db_util.dart';
import 'package:http/http.dart' as http;

class RepositoryTransaction with ChangeNotifier {
  String _token;
  RepositoryTransaction(this._token);
  List<TransactionModel> _items = [];
  double somaReceitas = 0;
  double somaDespesas = 0;

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

    _items = retorno;
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

  void removeTransactionSqflite(int transactionId) async {
    Database db = await DBHelper.instance.database;

    await db.delete(
      DBHelper.tableTransaction,
      where: "idTransaction = ?",
      whereArgs: [transactionId],
    );
    int index =
        _items.indexWhere((p) => p.idTransaction == transactionId.toString());
    final trasaction = _items[index];
    _items.remove(trasaction);
    notifyListeners();
  }

  void updateTransactionSqflite(TransactionModel transaction) async {
    Database db = await DBHelper.instance.database;

    Map<String, dynamic> row = {
      DBHelper.idTransaction: transaction.idTransaction.toString(),
      DBHelper.name: transaction.name.toString(),
      DBHelper.categoria: transaction.categoria.toString(),
      DBHelper.data: transaction.data.toString(),
      DBHelper.valor: transaction.valor,
      DBHelper.formaPagamento: transaction.formaPagamento.toString(),
      DBHelper.tipoTransacao: int.parse(transaction.tipoTransacao.toString()),
      DBHelper.latitude: transaction.location.latitude,
      DBHelper.longitude: transaction.location.longitude,
      DBHelper.address: transaction.location.address.toString(),
    };
    await db.update(
      DBHelper.tableTransaction,
      row,
      where: "idTransaction = ?",
      whereArgs: [transaction.idTransaction],
    );

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

  Future<void> _carregaTabela() async {}

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
          'description': transaction.name,
          'paymentValue': transaction.valor,
          'paymentType': transaction.formaPagamento,
          'tansactionType': transaction.tipoTransacao,
          'tansactionDate': transaction.data,
          'latitude': transaction.location.latitude,
          'longitude': transaction.location.longitude,
          'address': transaction.location.address,
          'categoryId': int.parse(transaction.categoria),
          'userId': userId
        },
      ),
    );

    final body = jsonDecode(response.body);
    print(body);
    // if (body['sucesso'] != true) {
    //   throw AuthException(body['erros'].toString());
    // }
  }

  Future<void> saveTransactionSql(Map<String, Object> transactionData) async {
    bool hasId = transactionData['IdTransaction'] != "";
    bool hasLatitude = transactionData['IdTransaction'] != "";
    print(hasLatitude);

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
      await updateTransactionSql(transaction);
    } else {
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
          'description': transaction.name,
          'paymentValue': transaction.valor,
          'paymentType': transaction.formaPagamento,
          'tansactionType': transaction.tipoTransacao,
          'tansactionDate': transaction.data,
          'latitude': transaction.location.latitude,
          'longitude': transaction.location.longitude,
          'address': transaction.location.address,
          'categoryId': int.parse(transaction.categoria),
          'UserId': userId,
        },
      ),
    );

    print(response.body);
  }

  Future<void> removeTransactionSql(String idTransaction) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'];

    final url =
        'https://webudgetpuc.azurewebsites.net/api/Transaction/$idTransaction';

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

  void saveTransactionSqflite(Map<String, dynamic> object, String operacao) {
    final transaction = TransactionModel(
      idTransaction: object['Id'].toString(),
      name: object['Description'] as String,
      categoria: object['CategoryId'].toString(),
      data: object['TansactionDate'].toString().substring(0, 10),
      valor: object['PaymentValue'] as double,
      formaPagamento: object['PaymentType'] as String,
      tipoTransacao: object['TansactionType'].toString() == 'Expenses' ? 1 : 0,
      location: TransactionLocation(
        latitude: double.parse(object['Latitude'].toString()),
        longitude: double.parse(object['Longitude'].toString()),
        address: object['Address'] as String,
      ),
    );

    if (operacao == "Create") {
      insertTransacao(transaction);
    } else if (operacao == "Update") {
      updateTransactionSqflite(transaction);
    } else if (operacao == "Delete") {
      removeTransactionSqflite(int.parse(transaction.idTransaction));
    } else {
      print("Operação não encontrada");
    }
  }

  Future<double> totalReceitasMesCorrente() async {
    // List<TransactionModel> transaction = await selectTransaction();
    double totalReceitasMesCorrente = 0;
    // print(transaction);

    for (var element in _items) {
      int actualYear = int.parse(element.data.substring(0, 4));
      int actualMonth = int.parse(element.data.substring(5, 7));
      int actualDay = int.parse(element.data.substring(8, 10));
      DateTime accountDate = DateTime(actualYear, actualMonth, actualDay);

      if (accountDate.month == DateTime.now().month &&
          accountDate.year == DateTime.now().year &&
          element.tipoTransacao == 0) {
        totalReceitasMesCorrente += element.valor;
      }
    }
    somaReceitas = totalReceitasMesCorrente;
    return totalReceitasMesCorrente;
  }

  Future<double> totalDespesasMesCorrente() async {
    double totalDespesasMesCorrente = 0;

    // print(transaction);

    for (var element in _items) {
      int actualYear = int.parse(element.data.substring(0, 4));
      int actualMonth = int.parse(element.data.substring(5, 7));
      int actualDay = int.parse(element.data.substring(8, 10));
      DateTime accountDate = DateTime(actualYear, actualMonth, actualDay);

      if (accountDate.month == DateTime.now().month &&
          accountDate.year == DateTime.now().year &&
          element.tipoTransacao == 1) {
        totalDespesasMesCorrente += element.valor;
      }
    }
    somaDespesas = totalDespesasMesCorrente;

    return totalDespesasMesCorrente;
  }
}
