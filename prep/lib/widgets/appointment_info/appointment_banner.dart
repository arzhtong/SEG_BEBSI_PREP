import 'package:flutter/material.dart';
import 'package:prep/utils/query.dart';
import 'package:prep/utils/misc_functions.dart';

class AppointmentDetailsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('rootCard'),
      elevation: 3.0,
      color: FirestoreBackend().color,
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _TitleText("Date"),
            _SubtitleText(dateFormatter(FirestoreBackend().dateTime)),
            Divider(
              color: Colors.white,
            ),
            _TitleText("Time"),
            _SubtitleText(timeFormatter(FirestoreBackend().dateTime)),
            Divider(
              color: Colors.white,
            ),
            _TitleText("Location"),
            _SubtitleText(FirestoreBackend().location),
            Divider(
              color: Colors.white,
            ),
            _TitleText("Staff"),
            _SubtitleText(FirestoreBackend().doctorName),
          ],
        ),
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
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }
}