import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prep/utils/query.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/widgets/dashboard/help_dialog.dart';
class DailyCheckups extends StatefulWidget {
  final DateTime _appointmentDateTime;

  DailyCheckups(this._appointmentDateTime);

  @override
  State<StatefulWidget> createState() => _DailyCheckups();
}

class _DailyCheckups extends State<DailyCheckups> {
  List<Widget> myList = new List<Widget>();

  String monthAbbreviation(DateTime datetime) {
    const List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return months[datetime.month - 1].substring(0, 3);
  }

  CircleAvatar _getDailyCheckupIcon(int daysBeforeTest) {
    return CircleAvatar(
      backgroundColor:
          (daysBeforeTest == 0) ? Colors.red[400] : Colors.indigo[400],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget._appointmentDateTime
                .subtract(Duration(days: daysBeforeTest))
                .day
                .toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              //fontWeight: FontWeight.bold
            ),
          ),
          Text(
            monthAbbreviation(widget._appointmentDateTime),
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        ],
      ),
    );
  }

  Text _getDailyCheckupText(int daysBeforeTest) {
    switch (daysBeforeTest) {
      case 1:
        return Text("Your appointment is tomorrow");
      case 0:
        return Text("Your appointment is today!");
      default:
        return Text(daysBeforeTest.toString() + " days to your appointment");
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    List<Widget> instructionWidgets = new List();
    Map<dynamic, dynamic> dynamicInstructions = document['instructions'];

    dynamicInstructions.forEach((index, map) {
      Map<dynamic, dynamic> checkupMap = map;

      instructionWidgets.add(Column(
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
                          fontWeight: FontWeight.bold),
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
                  activeColor: Colors.green[500],
                  activeTrackColor: Colors.green[100],
                  value: checkupMap['answer'],
                  onChanged: (_) {
                    if (checkupMap['answer']) {
                      // Removes the old entry from the list
                      document.reference.updateData(
                          {('instructions.' + index + '.answer'): false});
                    } else {
                      document.reference.updateData(
                          {('instructions.' + index + '.answer'): true});
                    }
                  },
                ),
              ))
        ],
      ));
    });

    instructionWidgets.add(Divider(
      height: 9.0,
      color: Colors.white,
    ));

    return Container(
      padding: EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
            initiallyExpanded: true,
            leading: _getDailyCheckupIcon(document['daysBeforeTest']),
            title: _getDailyCheckupText(document['daysBeforeTest']),
            children: instructionWidgets),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Queries.dailyCheckupsSnapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          );
        } else {
          if (snapshot.data.documents.length > 0){
            return ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          } else {
            return EmptyScreenPlaceholder("There are no checkups", "");
          }
        }
      },
    );
  }
}
