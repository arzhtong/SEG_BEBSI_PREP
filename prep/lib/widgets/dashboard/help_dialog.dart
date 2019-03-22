import 'package:flutter/material.dart';

class MakeHelpIcon extends StatelessWidget {
   String info;

  MakeHelpIcon(this.info){
   if (info==null){
     info='';
   }
  }

  Widget build(BuildContext context) {
    return IconButton(
        icon: new Icon(Icons.help, color: Colors.indigo[50]),
        onPressed: () {
          _makeAlert(context, info);
        });
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
