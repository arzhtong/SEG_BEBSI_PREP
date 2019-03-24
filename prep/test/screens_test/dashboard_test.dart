import 'package:flutter_test/flutter_test.dart';
import 'package:prep/screens/dashboard.screen.dart';
import 'package:flutter/material.dart';

///
/// Dashboard contains a series of private helper methods found in the already
/// private _DashboardState class. They cannot be tested directly so they will
/// be tested through widget tests.
///
void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  testWidgets('Dashboard has...', (WidgetTester tester) async {
    Dashboard dashboard = Dashboard();

    await tester.pumpWidget(testableWidget(child: dashboard));
  });
}