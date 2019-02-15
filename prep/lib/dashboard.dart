import 'package:flutter/material.dart';

import './main.dart';
import './appointment_info.dart';
import './appointment.dart';

class Dashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: Text(
                          'Patient ID: 123456',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      Colors.indigo[500],
                      Colors.indigo[400],
                      Colors.blue[300],
                      Colors.blue[200],
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('Due Appointments'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PastAppointments()),
                  );
                },
              ),
              ListTile(
                title: Text('Past Appointments'),
                onTap: () {},
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Switch user'),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('About us'),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Past appointments'),
        ),
        body: Container(
          padding: EdgeInsets.all(20.00),
            child: ListView(
              children: <Widget>[
                CalendarText(),
                Divider(
                  color: Colors.white,
                ),
                CalendarCard(),
                Divider(
                  color: Colors.white,
                ),
                CalendarText(),
                Divider(
                  color: Colors.white,
                ),
                CalendarCard(),
                Divider(
                  color: Colors.white,
                ),
                CalendarCard(),
                Divider(
                  color: Colors.white,
                ),
                CalendarText(),
                Divider(
                  color: Colors.white,
                ),
                CalendarCard(),
                Divider(
                  color: Colors.white,
                ),
                CalendarCard(),
                Divider(
                  color: Colors.white,
                ),
                CalendarText(),
                Divider(
                  color: Colors.white,
                ),
                CalendarCard(),
                Divider(
                  color: Colors.white,
                ),
                CalendarCard(),
              ],
            )
          ),
    );
  }
}

class CalendarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentInfo())
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.today),
              title: Text("Cardiac FDG PET"),
              subtitle: Text("St. Thomas Hospital - 11:00 am"),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
        "7st February",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
    );
  }
}