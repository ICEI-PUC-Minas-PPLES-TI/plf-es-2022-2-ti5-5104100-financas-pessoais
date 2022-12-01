import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:we_budget/models/categoria_model.dart';

void main() {
  test('Deve criar uma categoria nova', () {
    final category =
        CategoriaModel(id: '1', codeCategoria: '123', nameCategoria: 'Estudos');
    expect(category.codeCategoria, '123');
  });

  // test('Deve retornar o toString correto', () {
  //   final category =
  //       CategoriaModel(id: '1', codeCategoria: '123', nameCategoria: 'Estudos');
  //   expect(category.toString(), '1-123');
  // });
}
