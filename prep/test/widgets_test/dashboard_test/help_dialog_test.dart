import 'package:prep/widgets/dashboard/help_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  testWidgets('Test to see it produces text', (WidgetTester tester) async {
    MakeHelpIcon helpicon = MakeHelpIcon('Hello');
    await tester.pumpWidget(
      testableWidget(
        child: Scaffold(body: helpicon),
      ),
    );
    await tester.tap(find.byWidget(helpicon));
    await tester.pump();
    expect(find.text('Hello'), findsOneWidget);
  });
  testWidgets('Test to see if it produces text with empty string',(WidgetTester tester) async{
     MakeHelpIcon helpicon = MakeHelpIcon('');
    await tester.pumpWidget(
      testableWidget(
        child: Scaffold(body: helpicon),
      ),
    );
    await tester.tap(find.byWidget(helpicon));
    await tester.pump();
    expect(find.text(''), findsOneWidget);
  });
   testWidgets('Test to see if it produces text with null string',(WidgetTester tester) async{
     MakeHelpIcon helpicon = MakeHelpIcon(null);
    await tester.pumpWidget(
      testableWidget(
        child: Scaffold(body: helpicon),
      ),
    );
    await tester.tap(find.byWidget(helpicon));
    await tester.pump();
    expect(find.widgetWithText(AlertDialog, 'No Description Available'),findsOneWidget);
  });
}
