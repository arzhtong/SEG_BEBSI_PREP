import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';

class DailyCheckups extends StatefulWidget {
  final String _appointmentID;
  DailyCheckups(this._appointmentID);

  @override
  State<StatefulWidget> createState() {
    print("DailyCheckups screen recieved: " + _appointmentID);
    return _DailyCheckups();
  }
}

class _DailyCheckups extends State<DailyCheckups> {
  List<Widget> myList = new List<Widget>();

  IconData _assignIcon(int index) {
    switch(index){
      case 0: {return Icons.event;}
      break;
      case 1: {return Icons.filter_1;}
      break;
      case 2: {return Icons.filter_2;}
      break;
      case 3: {return Icons.filter_3;}
      break;
      case 4: {return Icons.filter_4;}
      break;
      case 5: {return Icons.filter_5;}
      break;
      case 6: {return Icons.filter_6;}
      break;
      case 7: {return Icons.filter_7;}
      break;
      case 8: {return Icons.filter_8;}
      break;
      case 9: {return Icons.filter_9;}
      break;
      default: {return Icons.filter_9_plus;}
      break;
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    List<Widget> instructionWidgets = new List();
    Map<dynamic, dynamic> dynamicInstructions = document['instructions'];

    dynamicInstructions.forEach((index, map){
      Map<dynamic, dynamic> checkupMap = map;

      instructionWidgets.add(
        Column(
          children: <Widget>[
            Divider(),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 30.0),
                          child: Text(
                            (int.parse(index) + 1).toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                              checkupMap['question'].toString()
                          ),
                        )
                      ],
                    ),
                  ),
                  Switch(
                    value: checkupMap['answer'],
                    onChanged: (_){
                      if (checkupMap['answer']) {
                        // Removes the old entry from the list
                        document.reference.updateData({
                          ('instructions.' + index + '.answer') : false
                        });
                      } else {
                        document.reference.updateData({
                          ('instructions.' + index + '.answer') : true
                        });
                      }
                    },
                  )
                ],
              ),
            )
          ],
        )
      );
    });

    return ExpansionTile(
      initiallyExpanded: true,
      leading: Icon(_assignIcon(document['daysBeforeTest'])),
      title: Text(document['title']),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
          title: Container(
            padding: EdgeInsets.only(right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: instructionWidgets
            ),
          ),
        ),
      ],
    );
  }

  // forbidden characters: ".$[]#/"

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('appointments').document(widget._appointmentID).collection('dailyCheckups').orderBy('daysBeforeTest', descending: true).snapshots(),
      builder: (context, snapshot) {
      if (!snapshot.hasData) return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(),);
      return ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
      );},
    );
  }
}