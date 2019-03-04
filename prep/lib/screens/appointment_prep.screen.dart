import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './category.screen.dart';

class AppointmentPrep extends StatefulWidget {
  @override
  _AppointmentPrepState createState() => _AppointmentPrepState();
}

class _AppointmentPrepState extends State<AppointmentPrep> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('tests').document('VyyiBYwp0xX4nJyvX9oN').collection('prepCards').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>_makeData(context,snapshot.data.documents[index])
          );
        }
    );
  }

Widget _makeData(BuildContext context, DocumentSnapshot document) {
  return new Card(
    elevation: 5.0,
    child: InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Category(document['contents'])));
      },
      child: new Container(
        padding: EdgeInsets.all(20.0),
        child: new Row(
          children: <Widget>[
            new CircleAvatar(),
            new Padding(padding: EdgeInsets.all(10.0)),
            new Text(
              document['title'].toString(),
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ),
      ),
    ),
  );
}
}