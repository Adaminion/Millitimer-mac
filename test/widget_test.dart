// 2026-10-23
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:millitimer/main.dart';

void main() {
  testWidgets('Splash leads to timer with initial format',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MillitimerApp());

    // Version overlay is visible on the splash screen
    expect(find.text(kAppVersion), findsWidgets);

    // Leave the splash screen
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that the timer starts at 00:00:000
    expect(find.text('00:00:000'), findsOneWidget);

    // Verify that the control buttons are present
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Lap'), findsOneWidget);

    // Verify that the settings button is present
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // Version overlay is still visible on the timer screen
    expect(find.text(kAppVersion), findsOneWidget);
  });
}
