import 'package:flutter/material.dart';

import './main.dart';
import './appointment_info.dart';
import './dashboard.dart';

class PastAppointments extends StatelessWidget{
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
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
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
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.2, 0.3, 0.4, 0.6, 0.7, 0.8],
                  colors: [
                    Colors.deepPurple[200],
                    Colors.purple[200],
                    Colors.red[200],
                    Colors.deepOrange[200],
                    Colors.deepOrange[100],
                    Colors.yellow[200],
                  ],
                ),
              ),
            height: 200.0,
            ),
            ListTile(
              leading: Icon(Icons.today),
              title: Text("Heart PGE MRI test"),
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