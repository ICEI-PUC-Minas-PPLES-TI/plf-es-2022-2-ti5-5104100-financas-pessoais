import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:we_budget/Repository/account_repository.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/Repository/metas_repository.dart';
import 'package:we_budget/models/account.dart';
import 'package:we_budget/models/categoria_model.dart';
import 'package:we_budget/models/metas.dart';
import 'package:we_budget/models/transactions.dart';
import 'package:we_budget/utils/shared_preference.dart';

import '../Repository/transaction_repository.dart';

class UpdateLocalDatabase with ChangeNotifier {
  updateCategorySql() async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'] ?? '123';

    var dio = Dio();
    final response = await dio.get(
      'https://webudgetpuc.azurewebsites.net/api/Category',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    RepositoryCategory repo = RepositoryCategory();

    List<CategoriaModel> dataAtual = await repo.selectCategoria();
    if (dataAtual.isEmpty) {
      return (response.data as List).map((category) {
        repo.insertCategoria(CategoriaModel.fromJson(category));
      }).toList();
    }
  }

  updateAcconutSql() async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'] ?? '123';

    var dio = Dio();
    final response = await dio.get(
      'https://webudgetpuc.azurewebsites.net/api/Account',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    RepositoryAccount repo = RepositoryAccount();

    List<AccountModel> dataAtual = await repo.selectAcount();
    if (dataAtual.isEmpty) {
      return (response.data as List).map((metas) {
        repo.insertAccount(AccountModel.fromJson(metas));
      }).toList();
    }
  }

  updateMetasSql() async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'] ?? '123';

    var dio = Dio();
    final response = await dio.get(
      'https://webudgetpuc.azurewebsites.net/api/Budget',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    RepositoryMetas repo = RepositoryMetas();

    List<MetasModel> dataAtual = await repo.selectMetas();
    if (dataAtual.isEmpty) {
      return (response.data as List).map((metas) {
        repo.insertMetas(MetasModel.fromJson(metas));
      }).toList();
    }
  }

  updateTransactionSql() async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String token = userData['token'] ?? '123';

    var dio = Dio();
    final response = await dio.get(
      'https://webudgetpuc.azurewebsites.net/api/Transaction',
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    RepositoryTransaction repo = RepositoryTransaction();

    List<TransactionModel> dataAtual = await repo.selectTransaction();
    if (dataAtual.isEmpty) {
      return (response.data as List).map((transaction) {
        repo.insertTransacao(TransactionModel.fromJson(transaction));
      }).toList();
    }
  }
}
