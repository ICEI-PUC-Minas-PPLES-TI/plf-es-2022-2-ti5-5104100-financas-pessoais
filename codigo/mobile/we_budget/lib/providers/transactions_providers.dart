import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/transactions.dart';
import '../utils/db_util.dart';
import '../utils/location_util.dart';

class TransactionsProviders with ChangeNotifier {
  List<TransactionModel> _items = [];

  void _carregarDados() {
    DbUtil.deletar('transactions');
    DbUtil.insert(
      'transactions',
      {
        'id': "1",
        'name': "Almoço",
        'categoria': "Comida",
        'data': '2022-10-12',
        'valor': 100.01,
        'tipoTransacao': 1,
        'formaPagamento': "2",
        'latitude': 37.419857,
        'longitude': -122.078827,
        'address': "Rua A, Contagem",
      },
    );
    DbUtil.insert(
      'transactions',
      {
        'id': "2",
        'name': "Café",
        'categoria': "Comida",
        'data': '2022-10-12',
        'valor': 28.30,
        'tipoTransacao': 0,
        'formaPagamento': "2",
        'latitude': 37.419857,
        'longitude': -122.078827,
        'address': "Rua A, Contagem",
      },
    );
    DbUtil.insert(
      'transactions',
      {
        'id': "2",
        'name': "Café",
        'categoria': "Comida",
        'data': '2022-10-12',
        'valor': 28.30,
        'tipoTransacao': 0,
        'formaPagamento': "2",
        'latitude': 37.419857,
        'longitude': -122.078827,
        'address': "Rua A, Contagem",
      },
    );
    DbUtil.insert(
      'transactions',
      {
        'id': "3",
        'name': "Pão de queijo",
        'categoria': "Comida",
        'data': '2022-10-12',
        'valor': 28.30,
        'tipoTransacao': 0,
        'formaPagamento': "2",
        'latitude': 37.419857,
        'longitude': -122.078827,
        'address': "Rua A, Contagem",
      },
    );
  }

  Future<void> loadTransaction() async {
    _carregarDados();
    final dataList = await DbUtil.getData('transactions');
    _items = dataList
        .map(
          (item) => TransactionModel(
            idTransaction: item['id'],
            name: item['name'],
            categoria: item['categoria'],
            data: item['data'],
            valor: item['valor'],
            formaPagamento: item['formaPagamento'],
            tipoTransacao: item['tipoTransacao'],
            location: TransactionLocation(
              latitude: item['latitude'],
              longitude: item['longitude'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }

  List<TransactionModel> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  TransactionModel itemByIndex(int index) {
    return _items[index];
  }

  Future<void> addTransaction(
    String name,
    String categoria,
    String data,
    double valor,
    String formaPagamento,
    int tipoTransacao,
    position,
  ) async {
    var address = await LocationUtil.getAddressFrom(position);
    final newTransation = TransactionModel(
      idTransaction: Random().nextDouble().toString(),
      name: name,
      data: data,
      categoria: categoria,
      formaPagamento: formaPagamento,
      tipoTransacao: tipoTransacao,
      valor: valor,
      location: TransactionLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      ),
    );

    _items.add(newTransation);

    DbUtil.insert(
      'transactions',
      {
        'id': newTransation.idTransaction,
        'name': newTransation.name,
        'categoria': newTransation.categoria,
        'data': newTransation.data,
        'valor': newTransation.valor,
        'formaPagamento': newTransation.formaPagamento,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
      },
    );
    notifyListeners();
  }
}
