import 'package:flutter_test/flutter_test.dart';
import 'package:prep/widgets/dashboard/calendar_label.dart';

void main() {
  final calendarLabel = CalendarLabel(DateTime(2019, 1, 1, 1, 0, 0, 0, 0));

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

    dateTimeList.forEach((map) {
      test('Test ' + (dateTimeList.indexOf(map) + 1).toString(), () {
        expect(
            calendarLabel.dateTimeFormatter(map['rawDate']), map['stringDate']);
      });
    });
  });

  testWidgets('CalendarCard has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(CalendarLabel(DateTime(2019, 1, 1, 1, 0, 0, 0, 0)));

    final titleFinder = find.text(
        calendarLabel.dateTimeFormatter(DateTime(2019, 1, 1, 1, 0, 0, 0, 0)));

    expect(titleFinder, findsOneWidget);
  });
}
