import 'package:flutter_test/flutter_test.dart';
import 'package:prep/widgets/appointment_info/appointment_banner.dart';
import 'package:flutter/material.dart';
import 'package:prep/utils/backend.dart';
import 'package:prep/utils/misc_functions.dart';

void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  setUp(() => FirestoreBackend().setBackendParams(
      "appID",
      "testID",
      "appName",
      "appLocation",
      DateTime(2027, 1, 1, 1, 0, 0, 0, 0),
      "doctorName",
      Colors.blue));

  testWidgets(
      "Appointment banner should contain all 4 correct text widgets and the correct color",
      (WidgetTester tester) async {
    AppointmentDetailsBanner appointmentDetailsBanner =
        AppointmentDetailsBanner();

    await tester.pumpWidget(testableWidget(child: appointmentDetailsBanner));

    final rootCardWidgetFinder = find.byKey(Key('rootCard'));

    Color bannerColor =
        (rootCardWidgetFinder.evaluate().single.widget as Card).color;

    expect(find.text(dateFormatter(DateTime(2027, 1, 1, 1, 0, 0, 0, 0))),
        findsOneWidget);
    expect(find.text(timeFormatter(DateTime(2027, 1, 1, 1, 0, 0, 0, 0))),
        findsOneWidget);
    expect(find.text('appLocation'), findsOneWidget);
    expect(find.text('doctorName'), findsOneWidget);
    expect(bannerColor, Colors.blue);
  });

  tearDown(() => FirestoreBackend()
      .setBackendParams(null, null, null, null, null, null, null));
}
