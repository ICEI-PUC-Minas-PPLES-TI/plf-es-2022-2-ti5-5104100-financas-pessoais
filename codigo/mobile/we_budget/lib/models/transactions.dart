import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TransactionLocation {
  final double latitude;
  final double longitude;
  final String? address;

  const TransactionLocation({
    this.address,
    required this.latitude,
    required this.longitude,
  });

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}

class Transaction {
  final String id;
  final String name;
  final String categoria;
  final String data;
  final double valor;
  final String formaPagamento;
  final TransactionLocation location;

  Transaction({
    required this.id,
    required this.name,
    required this.categoria,
    required this.data,
    required this.valor,
    required this.formaPagamento,
    required this.location,
  });
}
