import 'package:flutter/material.dart';
import 'package:prep/utils/query.dart';

class AppointmentDetailsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TitleText("I'm title text"),
          SubtitleText("I'm subtitle text"),
        ],
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;

  TitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(

      ),
    );
  }
}

class SubtitleText extends StatelessWidget {
  final String text;

  SubtitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(

      ),
    );
  }
}