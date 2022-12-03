import 'dart:async';

import 'package:test/test.dart';
import 'package:we_budget/models/auth.dart';

void main() {
  test('Future.value() returns the value', () async {
    var value = await Auth()
        .authenticateLogin('name', 'user@test.com.br', '123aA*', 'login');
    expect(value['sucesso'], equals(true));
  });
}
