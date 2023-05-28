import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_main.dart';

void main() {
  testWidgets('Mediator Simple - int increments test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.textContaining(': 0'), findsNWidgets(6));
    expect(find.textContaining(':0'), findsNWidgets(3));
    expect(find.textContaining(': 1'), findsNothing);
    expect(find.textContaining(':1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.textContaining(': 0'), findsNWidgets(2));
    expect(find.text('int1: 2'), findsOneWidget);
    expect(find.text('int1:2'), findsOneWidget);
    expect(find.text('sum: 2'), findsOneWidget);
    expect(find.text('sum(computed): 2'), findsOneWidget);
    expect(find.text('sum2(computed): 2'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.textContaining(': 0'), findsNWidgets(2));
    expect(find.text('int1: 3'), findsOneWidget);
    expect(find.text('int1:3'), findsOneWidget);
    expect(find.text('sum: 3'), findsOneWidget);
    expect(find.text('sum(computed): 3'), findsOneWidget);
    expect(find.text('sum2(computed): 3'), findsOneWidget);

    /// tab2
    await tester.tap(find.byIcon(Icons.beach_access_sharp));
    await tester.pump();
    expect(find.textContaining(': 0'), findsNWidgets(2));
    expect(find.text('int1: 3'), findsOneWidget);
    expect(find.text('int1:3'), findsOneWidget);
    expect(find.text('sum: 3'), findsOneWidget);
    expect(find.text('sum(computed): 3'), findsOneWidget);
    expect(find.text('sum2(computed): 3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.textContaining(': 0'), findsOneWidget);
    expect(find.text('int1: 5'), findsOneWidget);
    expect(find.text('int1:5'), findsOneWidget);
    expect(find.text('int2: 2'), findsOneWidget);
    expect(find.text('int2:2'), findsOneWidget);
    expect(find.text('sum: 7'), findsOneWidget);
    expect(find.text('sum(computed): 7'), findsOneWidget);
    expect(find.text('sum2(computed): 7'), findsOneWidget);

    /// tab3
    await tester.tap(find.byIcon(Icons.brightness_5_sharp));
    await tester.pump();
    expect(find.textContaining(': 0'), findsOneWidget);
    expect(find.text('int1: 5'), findsOneWidget);
    expect(find.text('int1:5'), findsOneWidget);
    expect(find.text('int2: 2'), findsOneWidget);
    expect(find.text('int2:2'), findsOneWidget);
    expect(find.text('sum: 7'), findsOneWidget);
    expect(find.text('sum(computed): 7'), findsOneWidget);
    expect(find.text('sum2(computed): 7'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('int1: 6'), findsOneWidget);
    expect(find.text('int1:6'), findsOneWidget);
    expect(find.text('int2: 3'), findsOneWidget);
    expect(find.text('int2:3'), findsOneWidget);
    expect(find.text('int3: 1'), findsOneWidget);
    expect(find.text('int3:1'), findsOneWidget);
    expect(find.text('sum: 10'), findsOneWidget);
    expect(find.text('sum(computed): 10'), findsOneWidget);
    expect(find.text('sum2(computed): 10'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('int1: 9'), findsOneWidget);
    expect(find.text('int1:9'), findsOneWidget);
    expect(find.text('int2: 6'), findsOneWidget);
    expect(find.text('int2:6'), findsOneWidget);
    expect(find.text('int3: 4'), findsOneWidget);
    expect(find.text('int3:4'), findsOneWidget);
    expect(find.text('sum: 19'), findsOneWidget);
    expect(find.text('sum(computed): excess upper bound(19)'), findsOneWidget);
    expect(find.text('sum2(computed): excess upper bound(19)'), findsOneWidget);
  });

  // testWidgets('Mediator Simple - GridTile increments test',
  //     (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());

  //   /// List Tab
  //   ///
  //   /// goto list tab
  //   await tester
  //       .tap(find.byIcon(Icons.power_input_rounded, skipOffstage: false));
  //   await tester.pump();
  //   // Verify that list starts empty.
  //   expect(find.byType(GridTile, skipOffstage: false), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add, skipOffstage: false));
  //   await tester.pump();
  //   // Verify that list item incremented.
  //   expect(find.byType(GridTile, skipOffstage: false), findsOneWidget);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add, skipOffstage: false));
  //   await tester.pump();
  //   // Verify that list item incremented.
  //   expect(find.byType(GridTile, skipOffstage: false), findsNWidgets(2));
  // }, skip: false);
}
