import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:prep/screens/appointment.screen.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  // Firestore variables
  Widget cachedCalendar;
  List<DocumentSnapshot> documentList;
  QuerySnapshot testDocList;

  // Codes file variables
  Storage storage = new Storage();
  String codeFileState;
  bool fileExists = false;

  // Form validation variables
  TextEditingController codeController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool validationResultDb;
  bool validationResultFile;

  // Checks if an appointment ID exists in the codes file
  bool _documentInCodeFile(String value) {
    return codeFileState.split(',').contains(value);
  }

  // Writes data to the codes file
  Future<File> writeData() async {
    //must apply set state to make sure the calendar is redrawn
    setState(() {
      codeFileState = codeFileState + codeController.text + ',';
      codeController.text = '';
    });
    return storage.writeData(codeFileState);
  }

  // Writes data to the codes file
  Future<File> clearData() async {
    //must apply set state to make sure the calendar is redrawn
    setState(() {
      codeFileState = "";
      codeController.text = '';
    });
    return storage.writeData("");
  }

  // Checks if a code exists in the Firestore
  Future<bool> _isCodeInFirestore (String code) async {
    List<String> liveIDs = new List();

    await Firestore.instance.collection('appointments').getDocuments().then((query) {
      query.documents.forEach((document) {
        liveIDs.add(document.documentID);
      });
    });

    if (liveIDs.contains(code)) {
      return true;
    } else {
      return false;
    }
  }

  // Retrieves data from the Firestore and builds the calendar
  Future<Widget> _getDocData() async {
    // checking if a file already exists, if not, creating one
    if (!fileExists) {
      await storage.codeFileExists().then((result) {
        if (!result){
            storage.writeData("");
            fileExists = true;
          }
      });
    }

    await storage.readData().then((String value){
      codeFileState = value;
    });

    if (codeFileState == null){
      return null;
    } else if (codeFileState.isEmpty) {
      return _EmptyCalendarPlaceholder();
    } else {
      documentList = new List();
      List<Widget> calendarElements = new List();

      testDocList = await Firestore.instance.collection('appointments').orderBy('datetime').getDocuments();
      documentList = testDocList.documents;

      //Generates a list of filtered appointments
      List<DocumentSnapshot> filteredDocuments= new List();
      documentList.forEach((doc){
        if (_documentInCodeFile(doc.documentID)) {
          filteredDocuments.add(doc);
        }
      });
      documentList = filteredDocuments;

      //calendar building
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

      return ListView(
        padding: EdgeInsets.only(top: 20.0, bottom: 80.0, left: 10.0, right: 10.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: calendarElements,
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Dashboard"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: (){
                clearData();
              }
          )
        ],
      ),
      body: FutureBuilder(
        future: _getDocData(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return (cachedCalendar == null) ? LinearProgressIndicator(): Stack(children: <Widget>[cachedCalendar, LinearProgressIndicator()]);
            default:
              cachedCalendar = snapshot.data;
              return snapshot.data;
          }
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print(codeFileState);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: new Text("Enter appointment code"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: codeController,
                        validator: (value) {
                          if (value.isEmpty){
                            return "Please enter a code";
                          } else {
                            if (validationResultFile) {
                              return "This appointment is in your calendar";
                            } else {
                              if (validationResultDb){
                                return null;
                              } else {
                                return "Invalid code";
                              }
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
                              bool inFile = _documentInCodeFile(codeController.text);
                              bool inDatabase = await _isCodeInFirestore(codeController.text);

                              //every time this setState runs, _getDocData is executed. It's inefficient.
                              //setState(() {
                                this.validationResultDb = inDatabase;
                                this.validationResultFile = inFile;
                              //});

                              if(_formKey.currentState.validate()){
                                writeData();
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text('SUBMIT'),
                        ),
                      ),
                    ],
                  ),
                ),
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
                MaterialPageRoute(builder: (context) => Appointment(name))
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

class _EmptyCalendarPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Your calendar is empty",
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
        ),
        Text(
          "Add some appointments",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/prepApCode.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> codeFileExists() async {
    try {
      final file = await localFile;
      int length = await file.length();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}