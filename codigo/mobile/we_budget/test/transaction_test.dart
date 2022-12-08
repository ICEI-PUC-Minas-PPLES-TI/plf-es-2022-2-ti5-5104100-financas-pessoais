import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:we_budget/models/transactions.dart';

void main() {
  test('Deve criar uma transação nova', () {
    final transact = TransactionModel(
        idTransaction: '10',
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
    final transact = TransactionModel(
        idTransaction: '10',
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
    final transact = TransactionModel(
        idTransaction: '10',
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
}