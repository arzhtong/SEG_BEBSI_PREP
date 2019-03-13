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
            ListTile(
              leading: Container(
                //color: Colors.red,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 14.0,
                    child: Text(
                      (int.parse(index) + 1).toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                  checkupMap['question'],
                ),
              trailing: Container(
                //color: Colors.red,
                child: Switch(
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
                ),
              )
            )
          ],
        )
      );
    });

    instructionWidgets.add(
      Divider(
        height: 9.0,
        color: Colors.white,
      )
    );

    return Container(
      padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0, bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Icon(_assignIcon(document['daysBeforeTest'])),
          title: _getDailyCheckupTitle(document['daysBeforeTest'].toString()),
          children: instructionWidgets
        ),
      ),
    );
  }

  Text _getDailyCheckupTitle(String daysBeforeTest) {
    switch (daysBeforeTest) {
      case "1": return Text("Day to your appointment");
      case "0": return Text("Your appointment is today");
      default: return Text("Days to your appointment");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('appointments').document(widget._appointmentID).collection('dailyCheckups').orderBy('daysBeforeTest', descending: true).snapshots(),
      builder: (context, snapshot) {
      if (!snapshot.hasData) return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(),);
      return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
      );},
    );
  }
}