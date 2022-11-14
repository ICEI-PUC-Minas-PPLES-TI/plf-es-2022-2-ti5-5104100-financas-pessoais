// import 'dart:math';
// import 'package:collection/collection.dart';
//
//
// //
// List<PricePoint> get pricePoints {
//   final Random random = Random();
//   final randomNumbers = <double>[];
//   for (var i = 0; i <= 11; i++) {
//     randomNumbers.add(random.nextInt(5000).toDouble());
//   }
//
//   return randomNumbers
//       .mapIndexed(
//           (index, element) => PricePoint(x: index.toDouble(), y: element))
//       .toList();
// }