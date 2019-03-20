import 'package:flutter/material.dart';

import 'package:prep/utils/date_time_formatter.dart';

class CalendarLabel extends StatelessWidget {
  final DateTime dateTime;

  CalendarLabel(this.dateTime);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
        child: Text(
          DateTimeFormatter.dateFormatter(dateTime),
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
  }
}
