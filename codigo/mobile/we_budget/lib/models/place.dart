import 'dart:io';
import 'package:flutter/foundation.dart';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    this.address,
    required this.latitude,
    required this.longitude,
  });
}

class Place {
  final String id;
  final String name;
  final DateTime data;
  final double valor;
  final String formaPagamento;
  final PlaceLocation location;

  Place({
    required this.id,
    required this.name,
    required this.data,
    required this.valor,
    required this.formaPagamento,
    required this.location,
  });
}
