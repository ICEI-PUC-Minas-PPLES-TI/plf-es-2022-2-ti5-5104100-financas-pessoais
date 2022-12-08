import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/pages/location_form.dart';

void main() {
  testWidgets("Deve encontrar um Scaffold no form de localização", (WidgetTester tester) async {
    await tester.pumpWidget((MaterialApp(
        home: PlaceFormScreen(),
      )
    ));
    expect(find.byType(Scaffold), findsOneWidget);

  });
}