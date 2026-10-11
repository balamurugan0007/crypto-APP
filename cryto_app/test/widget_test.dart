// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cryto_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CryptoApp());
    // Just check the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
