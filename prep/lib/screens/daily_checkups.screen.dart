import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep/utils/query.dart';

class DailyCheckups extends StatefulWidget {
  final DateTime _appointmentDateTime;

  DailyCheckups(this._appointmentDateTime);

  @override
  State<StatefulWidget> createState() => _DailyCheckups();
}

class _DailyCheckups extends State<DailyCheckups> {
  List<Widget> myList = new List<Widget>();

  IconData _assignIcon(int index) {
    switch(index) {
      case 0: {return Icons.event;}
      case 1: {return Icons.filter_1;}
      case 2: {return Icons.filter_2;}
      case 3: {return Icons.filter_3;}
      case 4: {return Icons.filter_4;}
      case 5: {return Icons.filter_5;}
      case 6: {return Icons.filter_6;}
      case 7: {return Icons.filter_7;}
      case 8: {return Icons.filter_8;}
      case 9: {return Icons.filter_9;}
      default: {return Icons.filter_9_plus;}
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
          leading: (document['daysBeforeTest'] != 0)
              ? Icon(_assignIcon(document['daysBeforeTest']))
              : CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget._appointmentDateTime.day.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0
                        ),
                      ),
                      Text(
                        //TODO: Use the already written month name parser to apply month correctly
                        "Mar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0
                        ),
                      ),
                    ],
                  ),
                ),
          title: _getDailyCheckupTitle(document),
          children: instructionWidgets
        ),
      ),
    );
  }

  Text _getDailyCheckupTitle(DocumentSnapshot document) {
    switch (document['daysBeforeTest'].toString()) {
      case "1": return Text("Day to your appointment");
      case "0": return Text("Your appointment is today");
      default: return Text("Days to your appointment");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Queries.dailyCheckupsSnapshots,
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