import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:we_budget/models/account.dart';
import '../utils/db_util.dart';

class RepositoryAccount with ChangeNotifier {
  List<AccountModel> _account = [];
  String _token;

  RepositoryAccount(this._token);

  insertAccount(AccountModel account) async {
    Database db = await DBHelper.instance.database;

    Map<String, String> row = {
      DBHelper.idAccount: account.id.toString(),
      DBHelper.accountBalance: account.accountBalance.toString(),
      DBHelper.accountDateTime: account.accountDateTime.toString(),
    };
    await db.insert(DBHelper.tableAccount, row);
    _account.add(account);
    notifyListeners();
  }

  void updateAccountSqflite(AccountModel account) async {
    selectAcount();
    print("Entrou updateAccountSqflite");
    print("_accounts......$_account");

    Database db = await DBHelper.instance.database;

    Map<String, String> row = {
      DBHelper.idAccount: account.id.toString(),
      DBHelper.accountBalance: account.accountBalance.toString(),
      DBHelper.accountDateTime: account.accountDateTime.toString(),
    };
    await db.update(
      DBHelper.tableAccount,
      row,
      where: "idAccount = ?",
      whereArgs: [account.id],
    );
    print("Row.....$row");

    int index = _account.indexWhere((p) => p.id == account.id);
    print("index.....$index");
    if (index >= 0) {
      _account[index] = account;
      notifyListeners();
    }
  }

  Future<List<AccountModel>> selectAcount() async {
    print("Entrou select account");
    Database db = await DBHelper.instance.database;
    List<Map> accounts =
        await db.rawQuery("SELECT * FROM ${DBHelper.tableAccount}");
    print(accounts.length);
    if (accounts.isEmpty) {
      await _carregaTabela();
    }
    List<AccountModel> retorno = [];
    accounts = await db.rawQuery("SELECT * FROM ${DBHelper.tableAccount}");
    print(accounts);
    for (var account in accounts) {
      retorno.add(
        AccountModel(
          id: account[DBHelper.idAccount],
          accountBalance: account[DBHelper.accountBalance],
          accountDateTime: account[DBHelper.accountDateTime],
        ),
      );
    }

    _account = retorno;
    print("Lenght account..");
    print(_account.length);
    print(_account);
    return retorno;
  }

  // double saldoConta() {
  //   double total = _account
  //       .reduce((total, element) => total + element.accountBalance) as double;

  //   return total;
  // }

  Future<void> _carregaTabela() async {
    print("Entrou carrega tabela");
    AccountModel account1 = AccountModel(
        id: "2", accountBalance: 100, accountDateTime: "19-11-202");

    await insertAccount(account1);
  }

  void saveAccountSqflite(Map<String, dynamic> object, String operacao) {
    final account = AccountModel(
      id: object['Id'].toString(),
      accountBalance: object['AccountBalance'] as double,
      accountDateTime: object['AccountDateTime'].toString(),
    );

    if (operacao == "Create") {
      insertAccount(account);
    } else if (operacao == "Update") {
      print("Entrou update account");
      updateAccountSqflite(account);
    } else {
      print("Operação não encontrada");
    }
  }
}
