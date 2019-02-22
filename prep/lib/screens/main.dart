import 'package:flutter/material.dart';

import 'package:prep/screens/appointment.screen.dart';

void main() => runApp(
    MaterialApp(
      home: MyApp(),
    )
);

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Dashboard"),
        ),
        body: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            _CalendarCard(),
          ],
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Appointment())
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
                  stops: [0.1, 0.9],
                  colors: [
                    Colors.blue[200],
                    Colors.green[200],
                  ],
                ),
              ),
              height: 200.0,
            ),
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