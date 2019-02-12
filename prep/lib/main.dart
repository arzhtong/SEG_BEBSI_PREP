import 'package:flutter/material.dart';

import './dashboard.dart';

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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(

                      ),
                      labelText: "Patient code",
                      labelStyle: TextStyle(
                        color: Colors.white
                      )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      child: Text('LOG-IN'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
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