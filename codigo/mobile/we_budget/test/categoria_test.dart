import 'package:flutter_test/flutter_test.dart';
import 'package:we_budget/models/categoria_model.dart';

void main() {
  test('Deve criar uma categoria nova', () {
    final category = CategoriaModel(
        id: '1', codeCategoria: '123', nameCategoria: 'Estudos');
    expect(category.codeCategoria, '123');
  });
  test('Deve retornar o toString correto', () {
    final categoria = CategoriaModel(
        id: '18', codeCategoria: '10', nameCategoria: 'Pesca');
    expect(categoria.toString(), '18-10');
  });
}