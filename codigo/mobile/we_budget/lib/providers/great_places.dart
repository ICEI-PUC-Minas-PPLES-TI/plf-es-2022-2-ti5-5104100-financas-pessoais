import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/transations.dart';
import '../utils/db_util.dart';
import '../utils/location_util.dart';

class GreatTransations with ChangeNotifier {
  List<Transation> _items = [];

  Future<void> loadTransations() async {
    final dataList = await DbUtil.getData('Transations');
    _items = dataList
        .map(
          (item) => Transation(
            id: item['id'],
            name: item['name'],
            data: item['data'],
            valor: item['valor'],
            formaPagamento: item['formaPagamento'],
            location: TransationLocation(
              latitude: item['latitude'],
              longitude: item['longitude'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }

  List<Transation> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Transation itemByIndex(int index) {
    return _items[index];
  }

  Future<void> addTransation(
    String name,
    DateTime data,
    double valor,
    String formaPagamento,
      LatLng position,

  ) async {

    String address = await LocationUtil.getAddressFrom(position);
    final newTransation = Transation(
      id: Random().nextDouble().toString(),
      name: name,
      data: data,
      formaPagamento: formaPagamento,
      valor: valor,
      location: TransationLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      ),
    );

    _items.add(newTransation);
    DbUtil.insert('Transations', {
      'id': newTransation.id,
      'name': newTransation.name,
      'data': newTransation.data,
      'valor': newTransation.valor,
      'formaPagamento': newTransation.formaPagamento,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
    });
    notifyListeners();
  }
}
