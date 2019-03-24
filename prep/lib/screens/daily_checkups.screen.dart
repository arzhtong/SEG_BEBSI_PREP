import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep/utils/backend_provider.dart';

import 'package:prep/utils/query.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/utils/misc_functions.dart';

class DailyCheckups extends StatelessWidget {
  CircleAvatar _getDailyCheckupIcon(int daysBeforeTest, BuildContext context) {
    final BaseBackend backend = BackendProvider.of(context).backend;

    return CircleAvatar(
      backgroundColor:
          (daysBeforeTest == 0) ? Colors.red[400] : Colors.indigo[400],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            backend.dateTime
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
            monthAbbreviation(backend.dateTime),
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
                    document.reference.updateData({
                      // Toggles true/false for the daily checkup
                      ('instructions.' + index + '.answer'):
                          !checkupMap['answer'],
                      ('instructions.' + index + '.lastChecked'):
                          DateTime.now(),
                    });
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
            leading: _getDailyCheckupIcon(document['daysBeforeTest'], context),
            title: _getDailyCheckupText(document['daysBeforeTest']),
            children: instructionWidgets),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: BackendProvider.of(context).backend.dailyCheckupsSnapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          );
        } else {
          if (snapshot.data.documents != null &&
              snapshot.data.documents.length > 0) {
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
