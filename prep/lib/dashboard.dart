import 'package:flutter/material.dart';

import './main.dart';

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
                child: Text(
                  'Patient ID: 12345',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                ),
              ),
              ListTile(
                title: Text('Due Appointments'),
              ),
              ListTile(
                title: Text('Past Appointments'),
                onTap: () {},
              ),
              Divider(
                color: Colors.blue,
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
              Divider(
                color: Colors.blue,
              ),
              ListTile(
                title: Text('About us'),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Dashboard'),
        ),
        body: Container(
          padding: EdgeInsets.all(20.00),
            child: ListView(
              children: <Widget>[
                Text("1st January"),
                Divider(
                  color: Colors.white,
                ),
                Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text("Heart PGE MRI test"),
                        subtitle: Text("St. Thomas Hospital - 11:00 am"),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('BUY NOW'),
                              onPressed: (){},
                            ),
                            FlatButton(
                              child: Text('LISTEN'),
                              onPressed: (){},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Text("7st February"),
                Divider(
                  color: Colors.white,
                ),
                Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text("Heart PGE MRI test"),
                        subtitle: Text("St. Thomas Hospital - 11:00 am"),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('BUY NOW'),
                              onPressed: (){},
                            ),
                            FlatButton(
                              child: Text('LISTEN'),
                              onPressed: (){},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text("Heart PGE MRI test"),
                        subtitle: Text("St. Thomas Hospital - 11:00 am"),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('BUY NOW'),
                              onPressed: (){},
                            ),
                            FlatButton(
                              child: Text('LISTEN'),
                              onPressed: (){},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Text("1st January"),
                Divider(
                  color: Colors.white,
                ),
                Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text("Heart PGE MRI test"),
                        subtitle: Text("St. Thomas Hospital - 11:00 am"),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('BUY NOW'),
                              onPressed: (){},
                            ),
                            FlatButton(
                              child: Text('LISTEN'),
                              onPressed: (){},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Text("7st February"),
                Divider(
                  color: Colors.white,
                ),
                Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text("Heart PGE MRI test"),
                        subtitle: Text("St. Thomas Hospital - 11:00 am"),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('BUY NOW'),
                              onPressed: (){},
                            ),
                            FlatButton(
                              child: Text('LISTEN'),
                              onPressed: (){},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text("Heart PGE MRI test"),
                        subtitle: Text("St. Thomas Hospital - 11:00 am"),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('BUY NOW'),
                              onPressed: (){},
                            ),
                            FlatButton(
                              child: Text('LISTEN'),
                              onPressed: (){},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
    );
  }
}