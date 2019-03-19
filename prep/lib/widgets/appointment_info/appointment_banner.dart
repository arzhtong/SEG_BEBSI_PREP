import 'package:flutter/material.dart';
import 'package:prep/utils/query.dart';
import 'package:prep/utils/date_time_formatter.dart';

class AppointmentDetailsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Queries.color,
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _TitleText("Date"),
          _SubtitleText(DateTimeFormatter.dateFormatter(Queries.dateTime)),
          _TitleText("Time"),
          _SubtitleText("I'm subtitle text"),
          _TitleText("Location"),
          _SubtitleText("I'm subtitle text"),
          _TitleText("Staff member"),
          _SubtitleText("I'm subtitle text"),
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  final String text;

  _TitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class _SubtitleText extends StatelessWidget {
  final String text;

  _SubtitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w300
        ),
      ),
    );
  }
}