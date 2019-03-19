import 'package:flutter/material.dart';

class MakeHelpIcon extends StatelessWidget {
  final String info;

  MakeHelpIcon(this.info);

  Widget build(BuildContext context) {
    return IconButton(
        icon: new Icon(Icons.help, color: Colors.indigo[50]),
        onPressed: () {
          makeAlert(context, info);
        });
  }
}

void makeAlert(BuildContext context, String text) {
  var alertDialog = AlertDialog(
    title: Text("Tip",
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
