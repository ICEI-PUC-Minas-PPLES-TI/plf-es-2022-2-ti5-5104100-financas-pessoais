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

class TransactionModel {
  final String idTransaction;
  final String name;
  final String categoria;
  final String data;
  final double valor;
  final String formaPagamento;
  final int tipoTransacao;
  final TransactionLocation location;

  TransactionModel({
    required this.idTransaction,
    required this.name,
    required this.categoria,
    required this.data,
    required this.valor,
    required this.formaPagamento,
    required this.location,
    required this.tipoTransacao,
  });

  @override
  String toString() {
    String result =
        "$idTransaction - $name - $categoria - $data - $valor - Tipo transação : $tipoTransacao";
    return result.toString();
  }
}
