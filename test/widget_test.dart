// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:millitimer/main.dart';

void main() {
  testWidgets('Timer displays initial format', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MillitimerApp());

    // Verify that the timer starts at 00:00:000
    expect(find.text('00:00:000'), findsOneWidget);

    // Verify that the control buttons are present
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Lap'), findsOneWidget);

    // Verify that the settings button is present
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}