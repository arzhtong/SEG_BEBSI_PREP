import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './appointment.screen.dart';

class AppointmentInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppointmentInfoState();
  }
}

///
/// This solution loads all the data at once.
///
/// Advantage: Allows for analysis of the data as a whole before displaying it
/// Disadvantage: Does not update automatically
/// Disadvantage: It is fetched from Firestore every time the widget is built
///
class _AppointmentInfoState extends State<AppointmentInfo> {
  List<Widget> calendarElements;
  List<DocumentSnapshot> documentList;
  String numberOfElements = '0';

  QuerySnapshot testDocList;

  // The combination of 'async' and 'wait' makes this function execute
  //synchronously with the rest of the application so it doesn't freeze and
  //wait for the execution of the Firestore query. The widgets below are updated
  //because set state is called after await, so after the query has returned.
  void _getDocData() async {
    documentList = new List();
    calendarElements = new List();

    // await makes execution wait for the statement being executed to finish.
    //set state only runs after the calendar has finished building.
    //'then' waits for the operation before it.
    //That being getting the collection and ordering the documents.
    await Firestore.instance.collection('appointments').orderBy('datetime').getDocuments().then((query) {
      query.documents.forEach((document) {
        documentList.add(document);
        print(document.data['location']);
      });
      print("Live documents: " + documentList.length.toString());
    });

    // the command after await returns a Future<QuerySnapshot>. await is making
    //the assignment operator wait for the Future to stop being void and
    //become an actual QuerySnapshot object. It holds a list of documents.
    testDocList = await Firestore.instance.collection('appointments').orderBy('datetime').getDocuments();
    print("Number of documents in the snapshot: " + testDocList.documents.length.toString());

    // This is here to make sure the calendar is updated once the Firestore
    //query returns.
    setState(() {
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
    print("Widget appointmnet info screen init state");
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: calendarElements,
        )
      ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}