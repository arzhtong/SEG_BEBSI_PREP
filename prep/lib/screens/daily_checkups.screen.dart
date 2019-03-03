import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';

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
    List<Widget> instructionWidgets = new List();
    Map<dynamic, dynamic> dynamicInstructions = document['test'];

    SplayTreeMap sortedInstruciton = new SplayTreeMap.from(dynamicInstructions, (dynamic me, dynamic other){
      int myPlace = int.parse(me.toString().substring(0,1));
      int otherPlace = int.parse(other.toString().substring(0,1));

      return myPlace - otherPlace;
    });

    // Building each row containing an instruction
    sortedInstruciton.forEach((instruction, result){
      instructionWidgets.add(
        Container(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(instruction.toString().replaceAll('>', '.')),
              ),
              Switch(
                activeTrackColor: Colors.green[200],
                activeColor: Colors.green,
                inactiveTrackColor: Colors.red[200],
                inactiveThumbColor: Colors.red,
                value: result,
                onChanged: (_) {
                  if (result) {
                    Firestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot freshSnap = await transaction.get(document.reference);
                      await transaction.update(freshSnap.reference, {
                      ('test.'+ instruction): false
                      });
                    });
                  } else {
                    Firestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot freshSnap = await transaction.get(document.reference);
                      await transaction.update(freshSnap.reference, {
                        ('test.'+ instruction): true
                      });
                    });
                  }
                },
              )
            ],
          ),
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
      //The document ID is hard coded as we don't have a set way of identifying tests in appointments yet
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