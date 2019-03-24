import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:prep/widgets/list_parser/description_expansion_tile.dart';

void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  testWidgets(
      'Expansion tile is not expanded on arrival and hence only title is displayed',
      (WidgetTester tester) async {
    List<String> items = [
      "item1",
      "item2",
      "item3 hello",
      "item4 cars",
      "item5"
    ];

    DescriptiveExpansionTile expansionTile =
        DescriptiveExpansionTile("testCategory", "testDescription", items);

    await tester.pumpWidget(testableWidget(child: expansionTile));

    final titleFinder = find.text("testCategory");
    final descriptionFinder = find.text("testDescription");
    final itemListFinder =
        find.text("item1 • item2 • item3 hello • item4 cars • item5");

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsNothing);
    expect(itemListFinder, findsNothing);
  });

  testWidgets(
      'Expansion tile displays a card with a title, subtitle and description with the correct data formats after being expanded',
      (WidgetTester tester) async {
    List<String> items = [
      "item1",
      "item2",
      "item3 hello",
      "item4 cars",
      "item5"
    ];

    DescriptiveExpansionTile expansionTile =
        DescriptiveExpansionTile("testCategory", "testDescription", items);

    await tester.pumpWidget(testableWidget(child: expansionTile));

    final titleFinder = find.text("testCategory");

    await tester.tap(titleFinder);
    await tester.pump();

    final descriptionFinder = find.text("testDescription");
    final itemListFinder =
        find.text("item1 • item2 • item3 hello • item4 cars • item5");

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsOneWidget);
    expect(itemListFinder, findsOneWidget);
  });

  testWidgets(
      'Expanded expansion tile with an empty description displays no description section at all',
      (WidgetTester tester) async {
    List<String> items = [
      "item1",
      "item2",
      "item3 hello",
      "item4 cars",
      "item5"
    ];

    DescriptiveExpansionTile expansionTile =
        DescriptiveExpansionTile("testCategory", "", items);

    await tester.pumpWidget(testableWidget(child: expansionTile));

    final titleFinder = find.text("testCategory");

    await tester.tap(titleFinder);
    await tester.pump();

    final descriptionFinder = find.byKey(Key('description'));
    final itemListFinder =
        find.text("item1 • item2 • item3 hello • item4 cars • item5");

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsNothing);
    expect(itemListFinder, findsOneWidget);
  });

  testWidgets(
      'Expanded expansion tile with no items still contains space for the list',
      (WidgetTester tester) async {
    List<String> items = [];

    DescriptiveExpansionTile expansionTile =
        DescriptiveExpansionTile("testCategory", "testDescription", items);

    await tester.pumpWidget(testableWidget(child: expansionTile));

    final titleFinder = find.text("testCategory");

    await tester.tap(titleFinder);
    await tester.pump();

    final descriptionFinder = find.byKey(Key('description'));
    final itemListFinder = find.byKey(Key('listContainer'));

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsOneWidget);
    expect(itemListFinder, findsOneWidget);
  });

  testWidgets(
      'Expanded expansion tile with a null list of items still contains space for the list',
      (WidgetTester tester) async {
    DescriptiveExpansionTile expansionTile =
        DescriptiveExpansionTile("testCategory", "testDescription", null);

    await tester.pumpWidget(testableWidget(child: expansionTile));

    final titleFinder = find.text("testCategory");

    await tester.tap(titleFinder);
    await tester.pump();

    final descriptionFinder = find.byKey(Key('description'));
    final itemListFinder = find.byKey(Key('listContainer'));

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsOneWidget);
    expect(itemListFinder, findsOneWidget);
  });
}
