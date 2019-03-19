import 'package:flutter_test/flutter_test.dart';
import 'package:prep/widgets/dashboard/calendar_card.dart';
import 'package:flutter/material.dart';

void main() {
  final calendarCard = CalendarCard("name", "location",
      DateTime(2019, 1, 1, 1, 0, 0, 0, 0), "testID", "doctorName", "testName");

  group('Dates are formatted as dd mm yyyy', () {
    List<Map<String, dynamic>> dateTimeList = new List();

    dateTimeList.add({
      "rawDate": DateTime(2019, 1, 1, 1, 0, 0, 0, 0),
      "stringDate": "1 January 2019"
    });

    dateTimeList.add({
      "rawDate": DateTime(2019, 1, 1, 1, 1, 1, 1, 1),
      "stringDate": "1 January 2019"
    });

    dateTimeList.add({
      "rawDate": DateTime(2000, 12, 12, 12, 0, 0, 0, 0),
      "stringDate": "12 December 2000"
    });

    dateTimeList.add({
      "rawDate": DateTime(2014, 5, 6, 7, 40, 30, 3, 12),
      "stringDate": "6 May 2014"
    });

    dateTimeList.add({
      "rawDate": DateTime(2024, 11, 2, 10, 0, 0, 0, 5),
      "stringDate": "2 November 2024"
    });

    dateTimeList.add({
      "rawDate": null,
      "stringDate": "N/A"
    });

    dateTimeList.forEach((map) {
      test('Test ' + (dateTimeList.indexOf(map) + 1).toString(), () {
        expect(calendarCard.dateFormatter(map['rawDate']), map['stringDate']);
      });
    });
  });

  group('Times are formatted as hh : mm', () {
    List<Map<String, dynamic>> timeList = new List();

    timeList.add({
      "rawTime": DateTime(2019, 1, 1, 0, 0, 0, 0, 0),
      "stringTime": "00 : 00"
    });

    timeList.add({
      "rawTime": DateTime(2019, 1, 1, 4, 0, 1, 1, 1),
      "stringTime": "04 : 00"
    });

    timeList.add({
      "rawTime": DateTime(2000, 12, 12, 12, 0, 0, 0, 0),
      "stringTime": "12 : 00"
    });

    timeList.add({
      "rawTime": DateTime(2014, 5, 6, 15, 0, 0, 0, 0),
      "stringTime": "15 : 00"
    });

    timeList.add({
      "rawTime": DateTime(2024, 11, 2, 24, 0, 0, 0, 0),
      "stringTime": "00 : 00"
    });

    timeList.add({
      "rawTime": DateTime(2019, 1, 1, 0, 30, 0, 0, 0),
      "stringTime": "00 : 30"
    });

    timeList.add({
      "rawTime": DateTime(2019, 1, 1, 7, 30, 1, 1, 1),
      "stringTime": "07 : 30"
    });

    timeList.add({
      "rawTime": DateTime(2000, 12, 12, 12, 25, 0, 0, 0),
      "stringTime": "12 : 25"
    });

    timeList.add({
      "rawTime": DateTime(2014, 5, 6, 16, 45, 0, 0, 0),
      "stringTime": "16 : 45"
    });

    timeList.add({
      "rawTime": DateTime(2024, 11, 2, 23, 59, 0, 0, 0),
      "stringTime": "23 : 59"
    });

    timeList.add({
      "rawTime": null,
      "stringTime": "N/A"
    });

    timeList.forEach((map) {
      test('Test ' + (timeList.indexOf(map) + 1).toString(), () {
        expect(calendarCard.timeFormatter(map['rawTime']), map['stringTime']);
      });
    });
  });

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
    final date =
        find.text(calendarCard.dateFormatter(DateTime(2019, 3, 25, 10, 0)));
    final time =
        find.text(calendarCard.timeFormatter(DateTime(2019, 3, 25, 10, 0)));
    final appointmentCode = find.text("hjhfuz3ey");

    expect(appointmentTitleFinder, findsOneWidget);
    expect(location, findsOneWidget);
    expect(staffMember, findsOneWidget);
    expect(date, findsOneWidget);
    expect(time, findsOneWidget);
    expect(appointmentCode, findsOneWidget);
  });
}
