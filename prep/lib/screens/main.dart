import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prep/screens/appointment.screen.dart';

void main() => runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyApp(),
    )
);

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

///
/// This solution dynamically loads the data one record at a time
/// Advantage: Updates automatically
/// Disadvantage: Does not allow for whole data analysis before displaying it
///
class _MyAppState extends State<MyApp> {
  List<Widget> calendarElements;
  List<DocumentSnapshot> documents;

  //returns appointment ordered by datetime.
  void _getDocData(){
    Firestore.instance.collection('appointments').orderBy('datetime').getDocuments().then((query) {
      query.documents.forEach((document) {
        documents.add(document);
        print(document.data['location']);
      });
      print("Live documents: " + documents.length.toString());
    });
  }

  Widget _buildCalendar(BuildContext context, DocumentSnapshot document) {
    print(document.data.length);  //this is the number of fields in a document
    print("Build Calendar called " + document.documentID);
    return _CalendarCard(document.data['testID'], document.data['location'],  document.data['datetime']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Dashboard"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('appointments').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => _buildCalendar(context, snapshot.data.documents[index]),
          );
        },
      )
    );
  }
}

class _CalendarLabel extends StatelessWidget {
  final DateTime dateTime;

  _CalendarLabel(this.dateTime);

  @override
  Widget build(BuildContext context) {
    return Text(
        dateTime.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final String name;
  final String location;
  final DateTime dateTime;

  _CalendarCard(this.name, this.location, this.dateTime);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child:  Card(
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
                title: Text(name),
                subtitle: Text(location + " - " + dateTime.toString()),
                //subtitle: Text("St. Thomas Hospital - 11:00 am"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}