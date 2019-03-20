import 'package:flutter/material.dart';

import 'package:prep/utils/misc_functions.dart';

class CalendarLabel extends StatelessWidget {
  final DateTime dateTime;

  CalendarLabel(this.dateTime);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
        child: Text(
          dateFormatter(dateTime),
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
  }
}
