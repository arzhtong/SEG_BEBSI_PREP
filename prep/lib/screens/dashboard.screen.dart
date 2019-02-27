import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prep/screens/appointment.screen.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  Column cachedCalendar;
  List<DocumentSnapshot> documentList;
  QuerySnapshot testDocList;

  Future<Widget> _getDocData() async {
    documentList = new List();
    List<Widget> calendarElements = new List();

    testDocList = await Firestore.instance.collection('appointments').orderBy('datetime').getDocuments();
    documentList = testDocList.documents;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: calendarElements,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Dashboard"),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 10.0, right: 10.0),
        children: <Widget>[
          FutureBuilder(
              future: _getDocData(),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return (cachedCalendar == null) ? Text('Waiting.') : cachedCalendar;
                  default:
                    cachedCalendar = snapshot.data;
                    return snapshot.data;
                }
              }
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: new Text("Enter appointment code"),
              content: SingleChildScrollView(
                child: MyCustomForm(),
              ),
            )
          );
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
        padding: EdgeInsets.only(left: 10.0),
        child: Text(
          dateTimeFormater(dateTime),
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  String dateTimeFormater(DateTime datetime){
    String formattedString = datetime.day.toString();

    switch(datetime.month){
      case 1: {formattedString = formattedString + " January";}
      break;
      case 2: {formattedString = formattedString + " February";}
      break;
      case 3: {formattedString = formattedString + " March";}
      break;
      case 4: {formattedString = formattedString + " April";}
      break;
      case 5: {formattedString = formattedString + " May";}
      break;
      case 6: {formattedString = formattedString + " June";}
      break;
      case 7: {formattedString = formattedString + " July";}
      break;
      case 8: {formattedString = formattedString + " August";}
      break;
      case 9: {formattedString = formattedString + " September";}
      break;
      case 10: {formattedString = formattedString + " October";}
      break;
      case 11: {formattedString = formattedString + " November";}
      break;
      case 12: {formattedString = formattedString + " December";}
      break;
      default: {formattedString = formattedString + " Error";}
      break;
    }

    return formattedString + " " + datetime.year.toString();
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
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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

// Create a Form Widget
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  bool validationResult;
  TextEditingController codeController = new TextEditingController();

  ///TODO split this function into checking if the code already exists in the local JSON and into checking if the code exists in Firebase
  ///This code can maybe be written in the onpress of the button.
  ///Think about loading the JSON file into a variable upon startup so I don't have to wait for it
  Future<bool> _validateAppointmentCode (String code) async {
    List<String> liveIDs = new List();

    await Firestore.instance.collection('appointments').getDocuments().then((query) {
        query.documents.forEach((document) {
          liveIDs.add(document.documentID);
        });
    });

    //print("Entered code: " + code);

    if (liveIDs.contains(code)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: codeController,
            validator: (value) {
              if (value.isEmpty){
                return "Please enter a value";
              } else {
                if (validationResult){
                  return null;
                } else {
                  return "Invalid code";
                }
              }
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              onPressed: () async {
                if (codeController.text.isEmpty){
                  _formKey.currentState.validate();
                } else {
                  bool result = await _validateAppointmentCode(codeController.text);

                  //print("Result: " + result.toString());

                  setState(() {
                    this.validationResult = result;
                  });

                  if(_formKey.currentState.validate()){
                    Navigator.pop(context);
                  }
                }
              },
              child: Text('SUBMIT'),
            ),
          ),
        ],
      ),
    );
  }
}