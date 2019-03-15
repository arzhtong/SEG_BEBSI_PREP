import 'package:flutter/material.dart';

class CalendarLabel extends StatelessWidget {
  final DateTime dateTime;

  CalendarLabel(this.dateTime);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
        child: Text(
          dateTimeFormatter(dateTime),
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  String dateTimeFormatter(DateTime datetime) {
    const List<String> months = [
      "January", "February", "March", "April",
      "May", "June", "July", "August",
      "September", "October", "November", "December"
    ];

    String day = datetime.day.toString();
    String month = months[datetime.month - 1];
    String year = datetime.year.toString();

    return day + " " + month + " " + year;
  }
}