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
  List<DocumentSnapshot> documentList;
  String numberOfElements = '0';

  void _getDocData() async {
    documentList = new List();
    calendarElements = new List();

    Firestore.instance.collection('appointments').orderBy('datetime').getDocuments().then((query) {
      query.documents.forEach((document) {
        documentList.add(document);
        print(document.data['location']);
      });
      print("Live documents: " + documentList.length.toString());

      numberOfElements = "Live documents: " + documentList.length.toString();

      calendarElements.add(_CalendarLabel(documentList.elementAt(0).data['datetime']));
      calendarElements.add(_CalendarCard(documentList.elementAt(0).data['testID'], documentList.elementAt(0).data['location'], documentList.elementAt(0).data['datetime']));

      for (int i = 1; i < documentList.length; i++){
        if (documentList.elementAt(i).data['datetime'] != documentList.elementAt(i - 1).data['datetime']){
          calendarElements.add(_CalendarLabel(documentList.elementAt(i).data['datetime']));
          calendarElements.add(_CalendarCard(documentList.elementAt(i).data['testID'], documentList.elementAt(i).data['location'], documentList.elementAt(i).data['datetime']));
        } else {
          calendarElements.add(_CalendarCard(documentList.elementAt(i).data['testID'], documentList.elementAt(i).data['location'], documentList.elementAt(i).data['datetime']));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDocData();
    print("--------Mian state initialised--------");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Dashboard"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: calendarElements,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: () {

          }
      ),
    );
  }
}

class _CalendarLabel extends StatelessWidget {
  final DateTime dateTime;

  _CalendarLabel(this.dateTime);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        dateTimeFormater(dateTime),
        style: TextStyle(
            fontWeight: FontWeight.bold
        ),
      )
    );
  }

  String dateTimeFormater(DateTime datetime){
    String formatedString = datetime.day.toString();

    switch(datetime.month){
      case 1: {formatedString = formatedString + " January";}
      break;
      case 2: {formatedString = formatedString + " February";}
      break;
      case 3: {formatedString = formatedString + " March";}
      break;
      case 4: {formatedString = formatedString + " April";}
      break;
      case 5: {formatedString = formatedString + " May";}
      break;
      case 6: {formatedString = formatedString + " June";}
      break;
      case 7: {formatedString = formatedString + " July";}
      break;
      case 8: {formatedString = formatedString + " August";}
      break;
      case 9: {formatedString = formatedString + " September";}
      break;
      case 10: {formatedString = formatedString + " October";}
      break;
      case 11: {formatedString = formatedString + " November";}
      break;
      case 12: {formatedString = formatedString + " December";}
      break;
      default: {formatedString = formatedString + " Error";}
      break;
    }

    return formatedString + " " + datetime.year.toString();
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
      //padding: EdgeInsets.all(10.0),
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