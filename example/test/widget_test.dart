// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_main.dart';

void main() {
  testWidgets('Mediator Simple - int increments test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.textContaining(': 0'), findsNWidgets(3));
    expect(find.textContaining(': 1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.textContaining(': 0'), findsNWidgets(2));
    expect(find.text('int1: 2'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.textContaining(': 0'), findsNWidgets(2));
    expect(find.text('int1: 3'), findsOneWidget);

    /// tab2
    await tester.tap(find.byIcon(Icons.beach_access_sharp));
    await tester.pump();
    expect(find.textContaining(': 0'), findsNWidgets(2));
    expect(find.text('int1: 3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.textContaining(': 0'), findsOneWidget);
    expect(find.text('int2: 2'), findsOneWidget);
    expect(find.text('int1: 3'), findsOneWidget);

    /// tab3
    await tester.tap(find.byIcon(Icons.brightness_5_sharp));
    await tester.pump();
    expect(find.textContaining(': 0'), findsOneWidget);
    expect(find.text('int2: 2'), findsOneWidget);
    expect(find.text('int1: 3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('int3: 1'), findsOneWidget);
    expect(find.text('int2: 2'), findsOneWidget);
    expect(find.text('int1: 3'), findsOneWidget);

    /// List Tab
    ///
    // goto list tab
    // await tester.tap(find.byIcon(Icons.power_input_rounded));
    // await tester.pump();
    // // Verify that list starts empty.
    // expect(find.byType(GridTile), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
    // // Verify that list item incremented.
    // expect(find.byType(GridTile), findsOneWidget);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
    // // Verify that list item incremented.
    // expect(find.byType(GridTile), findsNWidgets(2));
  });
}
