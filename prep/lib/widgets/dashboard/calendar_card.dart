import 'package:flutter/material.dart';

import 'package:prep/screens/appointment.screen.dart';
import 'package:prep/utils/misc_functions.dart';
import 'package:prep/utils/query.dart';

class CalendarCard extends StatelessWidget {
  final String name;
  final String location;
  final DateTime dateTime;
  final String testID;
  final String doctorName;
  final String testName;
  final List<Color> colors = [
    Colors.green[300],
    Colors.red[300],
    Colors.blue[300],
    Colors.orange[300]
  ];
  Color color;

  CalendarCard(this.name, this.location, this.dateTime, this.testID,
      this.doctorName, this.testName) {
    this.color = colors[name.hashCode % 4];
  }

  Widget _informationRow(String label, String content) {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            content,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
      child: Card(
        elevation: 3.0,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: color),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  testName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 30.0,
                              ),
                              _informationRow("Location: ", location),
                              _informationRow("Staff member: ", doctorName),
                              _informationRow(
                                  "Date: ", dateFormatter(dateTime)),
                              _informationRow(
                                  "Time: ", timeFormatter(dateTime)),
                            ],
                          ),
                        ],
                      ),
                    )),
                ListTile(
                  leading: Icon(Icons.code),
                  title: Text(name),
                ),
              ],
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    splashColor: Color.fromRGBO(255, 255, 255, 0.2),
                    onTap: () {
                      Queries.setAppointmentInfo(
                          this.name,
                          this.testID,
                          this.testName,
                          this.location,
                          this.dateTime,
                          this.doctorName,
                          this.color);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Appointment(0)));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
