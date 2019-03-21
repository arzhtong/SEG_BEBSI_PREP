import 'package:flutter_test/flutter_test.dart';
import 'package:prep/widgets/dashboard/calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:prep/utils/misc_functions.dart';

void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  testWidgets(
      'Calendar class has test name, location, staff member name, date, time and appintment code',
      (WidgetTester tester) async {
    CalendarCard calendarCard = CalendarCard(
        "hjhfuz3ey",
        "St. Thomas Hospiutal",
        DateTime(2019, 3, 25, 10, 0),
        "VyyiBYwp0xX4nJyvX9oN",
        "Eliana Reyes",
        "FDG PET Scan of the Heart");

    await tester.pumpWidget(testableWidget(child: calendarCard));

    final appointmentTitleFinder = find.text("FDG PET Scan of the Heart");
    final location = find.text("St. Thomas Hospiutal");
    final staffMember = find.text("Eliana Reyes");
    final date = find.text(dateFormatter(DateTime(2019, 3, 25, 10, 0)));
    final time = find.text(timeFormatter(DateTime(2019, 3, 25, 10, 0)));
    final appointmentCode = find.text("hjhfuz3ey");
    final containerFinder = find.byKey(Key('rootContainer'));

    Color boxColor = ((containerFinder.evaluate().single.widget as Container)
            .decoration as BoxDecoration).color;

    expect(boxColor, Colors.blue[300]);
    expect(appointmentTitleFinder, findsOneWidget);
    expect(location, findsOneWidget);
    expect(staffMember, findsOneWidget);
    expect(date, findsOneWidget);
    expect(time, findsOneWidget);
    expect(appointmentCode, findsOneWidget);
  });
}
