import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert';

List<TransactionModel> employeeFromJson(String str) =>
    List<TransactionModel>.from(
        json.decode(str).map((x) => TransactionModel.fromJson(x)));

String employeeToJson(List<TransactionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        idTransaction: json['id'].toString(),
        name: json['description'].toString(),
        categoria: json['categoryId'].toString(),
        data: json['tansactionDate'].toString().substring(0, 10),
        valor: double.parse(json['paymentValue'].toString()),
        formaPagamento: json['paymentType'].toString(),
        tipoTransacao: int.parse(json['tansactionType'].toString()),
        location: TransactionLocation(
          latitude: double.parse(json['latitude'].toString()),
          longitude: double.parse(json['longitude'].toString()),
          address: json['address'],
        ),
      );

  Map<String, dynamic> toJson() => {
        "idTransaction": idTransaction,
        "name": name,
        "categoria": categoria,
        "data": data,
        "valor": valor,
        "formaPagamento": valor,
        "tipoTransacao": formaPagamento,
        "latitude": location.latitude,
        "longitude": location.longitude,
        "address": location.address,
      };
}
