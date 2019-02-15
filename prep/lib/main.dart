import 'package:flutter/material.dart';

import './dashboard.dart';
import './appointment.dart';

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

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          //primarySwatch: Colors.indigo,
          backgroundColor: Colors.indigo,
          primaryColor: Colors.white,
          accentColor: Colors.white,
          hintColor: Colors.white,
        ),
        home: Scaffold(
          backgroundColor: Colors.indigo,
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.indigo[800],
                    Colors.indigo[700],
                    Colors.blue[600],
                    Colors.blue[400],
                  ],
                ),
              ),
              padding: EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(50.0),
                    child: Text(
                      'Prep.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 80.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      ),
                      labelText: "Patient code",
                      labelStyle: TextStyle(
                        color: Colors.blue[100],
                      )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      color: Colors.white,
                      child: Text(
                        'LOG-IN',
                        style: TextStyle(
                          color: Colors.indigo,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PastAppointments()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          )
        ),
    );
  }
}