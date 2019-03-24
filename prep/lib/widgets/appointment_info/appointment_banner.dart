import 'package:flutter/material.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/backend.dart';
import 'package:prep/utils/misc_functions.dart';

class AppointmentDetailsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BaseBackend backend = BackendProvider.of(context).backend;

    return Card(
      key: Key('rootCard'),
      elevation: 3.0,
      color: backend.color,
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _TitleText("Date"),
            _SubtitleText(dateFormatter(backend.dateTime)),
            Divider(
              color: Colors.white,
            ),
            _TitleText("Time"),
            _SubtitleText(timeFormatter(backend.dateTime)),
            Divider(
              color: Colors.white,
            ),
            _TitleText("Location"),
            _SubtitleText(backend.location),
            Divider(
              color: Colors.white,
            ),
            _TitleText("Staff"),
            _SubtitleText(backend.doctorName),
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
