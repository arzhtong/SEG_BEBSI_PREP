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
      case 8: {return Icons.filter_9;}
      break;
      default: {return Icons.filter_9_plus;}
      break;
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    List<Widget> instructionWidgets = new List();
    Map<dynamic, dynamic> dynamicInstructions = document['instructions'];

    SplayTreeMap sortedInstruction = new SplayTreeMap.from(dynamicInstructions, (dynamic me, dynamic other){
      int myPlace = int.parse(me.toString().substring(0,1));
      int otherPlace = int.parse(other.toString().substring(0,1));

      return myPlace - otherPlace;
    });

    // Building each row containing an instruction
    sortedInstruction.forEach((instruction, result){
      instructionWidgets.add(
        Column(
          children: <Widget>[
            Divider(),
            Container(
              padding: EdgeInsets.only(),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 30.0),
                            child: Text(
                              instruction.toString().replaceAll('>', '.').substring(0,2),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey
                              ),
                            ),
                          ),

                          Expanded(
                            child: Text(
                              instruction.toString().replaceAll('>', '.').substring(3, instruction.toString().length),
                            ),
                          )
                        ],
                      )
                  ),
                  Switch(
//                    activeTrackColor: Colors.green[200],
//                    activeColor: Colors.green,
//                    inactiveTrackColor: Colors.grey[300],
//                    inactiveThumbColor: Colors.grey,
                    value: result,
                    onChanged: (_) {
                      if (result) {
                        // This method works fine as only one user (the patient) will
                        // be editing the data so there is no risk of a race condition
                        document.reference.updateData({
                          ('instructions.'+ instruction): false
                        });
                      } else {
                        document.reference.updateData({
                          ('instructions.'+ instruction): true
                        });
                      }
                    },
                  )
                ],
              ),
            ),
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('appointments').document(widget._appointmentID).collection('dailyCheckups').orderBy('daysBeforeTest', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
        );},
    );
  }
}