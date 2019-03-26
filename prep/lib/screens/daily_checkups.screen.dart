import 'package:flutter/material.dart';
import 'package:prep/utils/backend_provider.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/utils/misc_functions.dart';

class DailyCheckups extends StatelessWidget {
  CircleAvatar _getDailyCheckupIcon(int daysBeforeTest, BuildContext context) {
    final BaseBackend backend = BackendProvider.of(context).backend;

    return CircleAvatar(
      key: Key('dateIcon'),
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

  Widget _buildListItem(BuildContext context, Map<String, dynamic> dataMap) {
    List<Widget> instructionWidgets = new List();
    Map<dynamic, dynamic> dynamicInstructions = dataMap['instructions'];

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
                    BackendProvider.of(context).backend.flickCheckupSwitch(
                        dataMap['title'], index, checkupMap['answer']);
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
            leading: _getDailyCheckupIcon(dataMap['daysBeforeTest'], context),
            title: _getDailyCheckupText(dataMap['daysBeforeTest']),
            children: instructionWidgets),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      key: Key('dailyCheckupsScreen'),
      stream: BackendProvider.of(context).backend.dailyCheckupsSnapshots,
      builder: (context, mapListSnapshot) {
        if (!mapListSnapshot.hasData) {
          return const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          );
        } else {
          if (mapListSnapshot.data != null && mapListSnapshot.data.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: mapListSnapshot.data.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, mapListSnapshot.data[index]),
            );
          } else {
            return EmptyScreenPlaceholder("There are no checkups", "");
          }
        }
      },
    );
  }
}
