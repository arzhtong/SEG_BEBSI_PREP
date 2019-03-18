import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prep/screens/appointment.screen.dart';
import 'package:prep/utils/query.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/utils/help_screen.dart';
class FaqParser extends StatelessWidget {
  final DateTime _appointmentDateTime;

  FaqParser(this._appointmentDateTime);

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      padding: EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
          title: Text(document['question']),
          children: <Widget>[
            ListTile(
              title: Text(
                document['answer'],
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                (document['chatShortcut'])
                    ? IconButton(
                        icon: Icon(Icons.chat),
                        color: Colors.indigo[400],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Appointment(
                                      Queries.appointmentID,
                                      Queries.testID,
                                      Queries.appointmentName,
                                      3,
                                      _appointmentDateTime)));
                        })
                    : Container(),
                (document['informationShortcut'])
                    ? IconButton(
                        icon: Icon(Icons.info),
                        color: Colors.deepPurple[400],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Appointment(
                                      Queries.appointmentID,
                                      Queries.testID,
                                      Queries.appointmentName,
                                      1,
                                      _appointmentDateTime)));
                        })
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("FAQ"),
          actions: <Widget>[MakeHelpIcon('This is a page used to give basic information regarding the test')]
      ),
      body: StreamBuilder(
        stream: Queries.faqSnapshots,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            );
          } else {
            if (snapshot.data.documents.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]),
              );
            } else {
              return EmptyScreenPlaceholder(
                  "There are no FAQs", "Contact your doctor for help");
            }
          }
        },
      ),
    );
  }
}
