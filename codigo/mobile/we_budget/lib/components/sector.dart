import 'dart:math';

import 'package:flutter/material.dart';

class Sector {
  final Color color;
  final double value;
  final String title;

  Sector({required this.color, required this.value, required this.title});
}


List<double> get randomNumbers {
  final Random random = Random();
  final randomNumbers = <double>[];
  for (var i = 1; i <= 7; i++) {
    randomNumbers.add(random.nextDouble() * 100);
  }

  return randomNumbers;
}

List<Sector> get industrySectors {
  return [
    Sector(
        color: Colors.redAccent,
        value: randomNumbers[0],
        title: 'Alimentação'),
    Sector(
        color: Colors.blueGrey,
        value: randomNumbers[1],
        title: 'Gasolina'),
    Sector(
        color: Colors.deepPurpleAccent,
        value: randomNumbers[2],
        title: 'Lazer'),
    Sector(
        color: Colors.yellow,
        value: randomNumbers[3],
        title: 'Contas básicas'),
    Sector(
        color: Colors.green,
        value: randomNumbers[4],
        title: 'Pets'),
    Sector(
        color: Colors.orange,
        value: randomNumbers[5],
        title: 'Saúde'),
    Sector(color: Colors.teal,
        value: randomNumbers[6],
        title: 'Imposto'),
  ];
}