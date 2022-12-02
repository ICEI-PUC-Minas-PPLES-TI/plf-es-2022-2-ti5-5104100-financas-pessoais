import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:we_budget/models/account.dart';
import 'package:we_budget/models/categoria_model.dart';
import 'package:we_budget/models/metas.dart';
import 'package:we_budget/models/transactions.dart';

void main() {
  group('Teste em models', ()
  {
    group('Testes da classe account.dart', () {
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
    });
    group('Testes da classe auth.dart', () {
      test('Deve autenticar', () {
        //AQUI MESTRE
      });
    });
    group('Testes da classe categoria.dart', () {
      test('Deve criar uma categoria nova', () {
        final category =
        CategoriaModel(id: '1', codeCategoria: '123', nameCategoria: 'Estudos');
        expect(category.codeCategoria, '123');
      });
      test('Deve retornar o toString correto', () {
        final categoria =
        CategoriaModel(id: '18', codeCategoria: '10', nameCategoria: 'Pesca');
        expect(categoria.toString(), '18-10');
      });
    });
    group('Testes da classe metas.dart', () {
      test('Deve criar uma meta nova', () {
        final meta =
        MetasModel(idCategoria: '09',
            idMeta: '09',
            dataMeta: '2022-10-10',
            valorMeta: 300.0,
            valorAtual: 250.0,
            recorrente: true);
        expect(meta.idCategoria, '09');
      });
      test('Deve retornar o toString correto', () {
        final meta =
        MetasModel(idCategoria: '09',
            idMeta: '09',
            dataMeta: '2022-10-10',
            valorMeta: 300.0,
            valorAtual: 250.0,
            recorrente: true);
        expect(meta.toString(), '09-09-2022-10-10-300.0-250.0-true');
      });
    });
    group('Testes da classe store.dart', () {

    });
    group('Testes da classe transactions.dart', () {
      test('Deve criar uma transação nova', () {
        final transact =
        TransactionModel(idTransaction: '10',
            name: 'Viagem rio',
            categoria: 'Pesca',
            data: '2022-10-10',
            valor: 30.0,
            formaPagamento: 'Pix',
            location: TransactionLocation(latitude: 20, longitude: 20),
            tipoTransacao: 1);
        expect(transact.idTransaction, '10');
      });
      test('Deve retornar a localização correta', () {
        final localizacao = LatLng(20, 20);
        final transact =
        TransactionModel(idTransaction: '10',
            name: 'Viagem rio',
            categoria: 'Pesca',
            data: '2022-10-10',
            valor: 30.0,
            formaPagamento: 'Pix',
            location: TransactionLocation(latitude: 20, longitude: 20),
            tipoTransacao: 1);
        expect(localizacao, transact.location.toLatLng());
      });
      test('Deve retornar o toString correto', () {
        final transact =
        TransactionModel(idTransaction: '10',
            name: 'Viagem rio',
            categoria: 'Pesca',
            data: '2022-10-10',
            valor: 30.0,
            formaPagamento: 'Pix',
            location: TransactionLocation(latitude: 20, longitude: 20),
            tipoTransacao: 1);
        expect(transact.toString(),
            '10 - Viagem rio - Pesca - 2022-10-10 - 30.0 - Tipo transação : 1');
      });
    });
  });
}
