import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:we_budget/Repository/categoria_repository.dart';
import 'package:we_budget/models/categoria_model.dart';

class ClientMock extends Mock implements Client {}

@GenerateMocks([Client])
void main() {
  test("cadastrar categoria", () async {
    final Map<String, dynamic> createCategoryData = {
      'nameCreateCategory': 'teste',
      'codeCreateCategory': '2',
    };

    final data = {
      "description": createCategoryData['nameCreateCategory'],
      "iconCode": createCategoryData['codeCreateCategory'],
    };

    final categoryRepository = RepositoryCategory('');
    categoryRepository.client = MockClient((request) async {
      return Response(jsonEncode(data), 200);
    });
    final item = await categoryRepository.createCategorySql(createCategoryData);
    expect(item['description'], 'teste');
  });

  test("atualizar categoria", () async {
    final category =
        CategoriaModel(id: '1', codeCategoria: '123', nameCategoria: 'update');

    final categoryUpdate = CategoriaModel(
        id: '1', codeCategoria: '123', nameCategoria: 'newUpdate');

    final data = {
      "description": categoryUpdate.nameCategoria,
      "iconCode": categoryUpdate.codeCategoria,
    };

    final categoryRepository = RepositoryCategory('');
    categoryRepository.client = MockClient((request) async {
      return Response(jsonEncode(data), 200);
    });
    final item = await categoryRepository.updateCategorySql(categoryUpdate);
    expect(item['description'], isNot(category.nameCategoria));
  });

  test("remover categoria", () async {
    final categoryDelete =
        CategoriaModel(id: '1', codeCategoria: '123', nameCategoria: 'delete');

    final data = {
      "description": categoryDelete.nameCategoria,
      "iconCode": categoryDelete.codeCategoria,
    };

    final categoryRepository = RepositoryCategory('');
    categoryRepository.client = MockClient((request) async {
      return Response(jsonEncode(data), 200);
    });
    final item = await categoryRepository.removeCategorySql(categoryDelete);
    expect(item['description'], categoryDelete.nameCategoria);
  });
}
