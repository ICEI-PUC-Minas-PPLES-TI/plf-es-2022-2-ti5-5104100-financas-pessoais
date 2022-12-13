import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:we_budget/components/location_input.dart';

void main() {
    void selectPosition(LatLng latLng) {}
    testWidgets("Deve encontrar um Container no widget location_input", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LocationInput(selectPosition),
      ));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets("Deve encontrar 3 Text's no widget location_input", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LocationInput(selectPosition),
      ));

      expect(find.byType(Text), findsNWidgets(3));
    });
}
