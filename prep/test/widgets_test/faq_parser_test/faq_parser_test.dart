import 'package:flutter_test/flutter_test.dart';
import 'package:prep/widgets/faq_parser/faq_expansion_tile.dart';
import 'package:flutter/material.dart';

void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  testWidgets('Expansion tile is not expanded and only shows question',
      (WidgetTester tester) async {
    FaqExpansionTile faqExpansionTile = FaqExpansionTile('Q', 'A', true, true);

    await tester.pumpWidget(testableWidget(child: faqExpansionTile));

    expect(find.text('Q'), findsOneWidget);
    expect(find.text('A'), findsNothing);
    expect(find.byKey(Key('chatButton')), findsNothing);
    expect(find.byKey(Key('infoButton')), findsNothing);
  });

  testWidgets('Expansion tile is expanded and shows question and answer',
      (WidgetTester tester) async {
    FaqExpansionTile faqExpansionTile =
        FaqExpansionTile('Q', 'A', false, false);

    await tester.pumpWidget(testableWidget(child: faqExpansionTile));

    expect(find.byKey(Key('expandableTile')), findsOneWidget);

    await tester.tap(find.text('Q'));
    await tester.pump();

    expect(find.text('Q'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.byKey(Key('chatButton')), findsNothing);
    expect(find.byKey(Key('infoButton')), findsNothing);
  });

  testWidgets(
      'Expansion tile is expanded and shows question, andwer and both shortcut buttons',
      (WidgetTester tester) async {
    FaqExpansionTile faqExpansionTile = FaqExpansionTile('Q', 'A', true, true);

    await tester.pumpWidget(testableWidget(child: faqExpansionTile));

    expect(find.byKey(Key('expandableTile')), findsOneWidget);

    await tester.tap(find.text('Q'));
    await tester.pump();

    expect(find.text('Q'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.byKey(Key('chatButton')), findsOneWidget);
    expect(find.byKey(Key('infoButton')), findsOneWidget);
  });
}
