import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/place.dart';
import '../utils/db_util.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            name: item['name'],
            data: item['data'],
            valor: item['valor'],
            formaPagamento: item['formaPagamento'],
            location: PlaceLocation(
              latitude: item['latitude'],
              longitude: item['longitude'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }

  List<Place> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  Future<void> addPlace(
    String name,
    DateTime data,
    double valor,
    String formaPagamento,
  ) async {
    final newPlace = Place(
      id: Random().nextDouble().toString(),
      name: name,
      data: data,
      formaPagamento: formaPagamento,
      valor: valor,
      location: PlaceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      ),
    );

    _items.add(newPlace);
    DbUtil.insert('places', {
      'id': newPlace.id,
      'name': newPlace.name,
      'data': newPlace.data,
      'valor': newPlace.valor,
      'formaPagamento': newPlace.formaPagamento,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
    });
    notifyListeners();
  }
}
