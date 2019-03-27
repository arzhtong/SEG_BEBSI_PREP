import 'package:flutter/material.dart';

import 'package:prep/screens/appointment.screen.dart';

class FaqExpansionTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool chatShortcut;
  final bool infoShortcut;

  FaqExpansionTile(
      this.question, this.answer, this.chatShortcut, this.infoShortcut);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
          key: Key('expandableTile'),
          title: Text(question),
          children: <Widget>[
            ListTile(
              title: Text(
                answer,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                (chatShortcut)
                    ? IconButton(
                        key: Key('chatButton'),
                        icon: Icon(Icons.chat),
                        color: Colors.indigo[400],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Appointment(3)));
                        })
                    : Container(),
                (infoShortcut)
                    ? IconButton(
                        key: Key('infoButton'),
                        icon: Icon(Icons.info),
                        color: Colors.deepPurple[400],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Appointment(1)));
                        })
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
