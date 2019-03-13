import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep/screens/appointment.screen.dart';

class FaqParser extends StatefulWidget {
  final String _testID;
  final String _appointmentID;
  final DateTime _appointmentDateTime;

  FaqParser(this._testID, this._appointmentID, this._appointmentDateTime);

  @override
  State<StatefulWidget> createState() {
    print("Appointment info recieved: " + _testID);
    return _FaqParserState();
  }
}

class _FaqParserState extends State<FaqParser> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return Container(
      padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0, bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
          title: Text(document['question']),
          children: <Widget>[
            ListTile(
              title: Text(
                document['answer'],
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                (document['chatShortcut'])
                  ? IconButton(
                      icon: Icon(Icons.chat),
                      color: Colors.indigo,
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            Appointment(widget._appointmentID, widget._testID, 3, widget._appointmentDateTime))
                        );
                      }
                    )
                  : Container(),
                (document['informationShortcut'])
                  ? IconButton(
                      icon: Icon(Icons.info),
                      color: Colors.deepPurple,
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            Appointment(widget._appointmentID, widget._testID, 1, widget._appointmentDateTime))
                        );
                      }
                    )
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
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('tests')
            .document(widget._testID).collection('faqs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(),);
          return ListView.builder(
            padding: EdgeInsets.only(top: 10.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
          );
        },
      ),
    );
  }
}