import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep/utils/query.dart';

class DailyCheckups extends StatefulWidget {
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
      stream: Queries.dailyCheckupsSnapshots,
      builder: (context, snapshot) {
      if (!snapshot.hasData) return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(),);
      return ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
      );},
    );
  }
}