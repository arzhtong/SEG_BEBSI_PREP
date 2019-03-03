import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyCheckups extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DailyCheckups();
  }
}

class _DailyCheckups extends State<DailyCheckups> {
  String testID;

  List<Widget> myList = new List<Widget>();

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    List<dynamic> dynamicInstructions = document['instructions'];
    List<String> instructions = dynamicInstructions.cast<String>().toList();
    List<Widget> instructionWidgets = new List();

    instructions.forEach((instruction){
      instructionWidgets.add(
        Container(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Text(instruction),
        )
      );
    });

    return ExpansionTile(
      leading: Icon(Icons.airport_shuttle),
      title: Text(document['title']),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
          title: Container(
            padding: EdgeInsets.only(right: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: instructionWidgets
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('tests').document('VyyiBYwp0xX4nJyvX9oN').collection('dailyCheckUps').orderBy('durationUntil', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
        );},
    );
  }
}