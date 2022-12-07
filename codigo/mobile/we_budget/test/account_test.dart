import 'package:flutter_test/flutter_test.dart';
import 'package:we_budget/models/account.dart';

void main() {
  test('Deve criar uma instancia de AccountModel', () {
    final accountModel = AccountModel(
        id: 'id', accountBalance: 200, accountDateTime: '01/12/2022');

    expect(accountModel.accountBalance, 200);
  });

  test('Deve retornar o toString correto', () {
    final accountModel = AccountModel(
        id: '1', accountBalance: 200, accountDateTime: '01/12/2022');
    expect(accountModel.toString(), '1-200.0');
  });
}