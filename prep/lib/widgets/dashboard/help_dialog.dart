import 'package:flutter/material.dart';

class MakeHelpIcon extends StatelessWidget {
  final String info;

  MakeHelpIcon(this.info);

  Widget build(BuildContext context) {
    if (info == null) {
      return AlertDialog(content: Text('No Description Available'));
    } else {
      return IconButton(
        key: Key("helpButton"),
          icon: new Icon(Icons.help, color: Colors.white),
          onPressed: () {
            _makeAlert(context, info);
          });
    }
  }

  void _makeAlert(BuildContext context, String text) {
    var alertDialog = AlertDialog(
      title: Text("Help",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0)),
      content: Text(text,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
