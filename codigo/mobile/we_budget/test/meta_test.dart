import 'package:flutter_test/flutter_test.dart';
import 'package:we_budget/models/metas.dart';

void main() {
  test('Deve criar uma meta nova', () {
    final meta = MetasModel(
        idCategoria: '09',
        idMeta: '09',
        dataMeta: '2022-10-10',
        valorMeta: 300.0,
        valorAtual: 250.0,
        recorrente: true);
    expect(meta.idCategoria, '09');
  });
  test('Deve retornar o toString correto', () {
    final meta = MetasModel(
        idCategoria: '09',
        idMeta: '09',
        dataMeta: '2022-10-10',
        valorMeta: 300.0,
        valorAtual: 250.0,
        recorrente: true);
    expect(meta.toString(), '09-09-2022-10-10-300.0-250.0-true');
  });
}