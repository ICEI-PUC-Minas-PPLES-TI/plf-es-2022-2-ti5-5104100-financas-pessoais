import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:we_budget/components/location_input.dart';

void main() {
  group("Teste LocationInput", () {
    void selectPosition(LatLng latLng) {}

    testWidgets("Teste LocationInput 1", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LocationInput(selectPosition),
      ));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets("Teste LocationInput 2", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LocationInput(selectPosition),
      ));

      expect(find.byType(Text), findsNWidgets(3));
    });
  });
}
