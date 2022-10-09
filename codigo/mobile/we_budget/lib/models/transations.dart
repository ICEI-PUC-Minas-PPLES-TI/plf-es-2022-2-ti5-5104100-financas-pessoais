import 'dart:io';
import 'package:flutter/foundation.dart';

class TransationLocation {
  final double latitude;
  final double longitude;
  final String address;

  const TransationLocation({
    this.address,
    required this.latitude,
    required this.longitude,
  });
}

class Transation {
  final String id;
  final String name;
  final DateTime data;
  final double valor;
  final String formaPagamento;
  final TransationLocation location;

  Transation({
    required this.id,
    required this.name,
    required this.data,
    required this.valor,
    required this.formaPagamento,
    required this.location,
  });
}
