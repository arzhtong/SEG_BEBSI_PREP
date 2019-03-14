import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:prep/utils/query.dart';
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

  // Subscribe user to message notifications
  void _subscribeToNotifications(String appointmentID) {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.autoInitEnabled();
    /* firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {},
      onResume: (Map<String, dynamic> message) {},
      onLaunch: (Map<String, dynamic> message) {},
    ); */
    firebaseMessaging.subscribeToTopic(appointmentID);
  }

  // Unsubscribe user from all message notifications
  // TODO: change structure of removing appointments, to allow unsubscribing from each appointment.
  void _unsubscribeFromNotifications() {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.deleteInstanceID();
  }

  // Checks if an appointment ID exists in the codes file
  bool _documentInCodeFile(String value) {
    return codeFileState.split(',').contains(value);
  }

  // Writes data to the codes file
  Future<File> writeData() async {
    _subscribeToNotifications(codeController.text);
    //must apply set state to make sure the calendar is redrawn
    setState(() {
      codeFileState = codeFileState + codeController.text + ',';
      codeController.text = '';
    });
    return storage.writeData(codeFileState);
  }

  // Writes data to the codes file
  Future<File> clearData() async {
    _unsubscribeFromNotifications();
    //must apply set state to make sure the calendar is redrawn
    setState(() {
      codeFileState = "";
      codeController.text = '';
    });
    return storage.writeData("");
  }

  // Overrides the data in the codes file
  Future<File> overrideData(String newFileState) async {
    codeFileState = newFileState;
    return await storage.writeData(newFileState);
  }

  // Checks if a code exists in the Firestore
  Future<bool> _isCodeInFirestore (String code) async {
    List<String> liveIDs = new List();

    await Queries.appointmentCodes.then((query) {
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

    //reading file and updating codeFileState
    await storage.readData().then((String value){
      codeFileState = value;
    });

    //reading appointments from the database and updating the codes file
    documentList = new List();
    List<Widget> calendarElements = new List();

    testDocList = await Queries.appointmentCodes;
    documentList = testDocList.documents;

    // Remove codes from the codes file that are past their date in the database
    List<String> documentIDs = new List();
    documentList.forEach((doc) {
      documentIDs.add(doc.documentID);
    });

    //print("Document IDs: " + documentIDs.toString());
    print(codeFileState.split(',').toString());

    String newCodeFileState = "";
    codeFileState.split(',').forEach((code){
      if (documentIDs.contains(code)){
        newCodeFileState = newCodeFileState + code + ',';
      }
    });

    await overrideData(newCodeFileState).then((_){});

    // print("NEW CODE FILE: " + newCodeFileState);

    // building the return widget based on the updated (current) codes file
    if (codeFileState == null){
      return null;
    } else if (codeFileState.isEmpty) {
      return _EmptyCalendarPlaceholder();
    } else {
      //Generates a list of filtered appointments
      List<DocumentSnapshot> filteredDocuments= new List();
      documentList.forEach((doc){
        if (_documentInCodeFile(doc.documentID)) {
          filteredDocuments.add(doc);
        }
      });
      documentList = filteredDocuments;

      calendarElements.add(_CalendarLabel(documentList.elementAt(0).data['datetime'].toDate()));
      calendarElements.add(_CalendarCard(documentList.elementAt(0).documentID, documentList.elementAt(0).data['location'], documentList.elementAt(0).data['datetime'].toDate(), documentList.elementAt(0).data['testID']));

      for (int i = 1; i < documentList.length; i++){
        if (documentList.elementAt(i).data['datetime'].toDate() == (documentList.elementAt(i - 1).data['datetime'].toDate())){
          calendarElements.add(_CalendarCard(documentList.elementAt(i).documentID, documentList.elementAt(i).data['location'], documentList.elementAt(i).data['datetime'].toDate(), documentList.elementAt(i).data['testID']));
        } else {
          calendarElements.add(_CalendarLabel(documentList.elementAt(i).data['datetime'].toDate()));
          calendarElements.add(_CalendarCard(documentList.elementAt(i).documentID, documentList.elementAt(i).data['location'], documentList.elementAt(i).data['datetime'].toDate(), documentList.elementAt(i).data['testID']));
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
          ),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){
                setState(() {});
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
            builder: (_) => _NewAppointmentDialog(this)
          );
        }
      ),
    );
  }
}

class _NewAppointmentDialog extends StatefulWidget {
  _DashboardState _parent;

  _NewAppointmentDialog(this._parent);

  @override
  State<StatefulWidget> createState() {
    return _NewAppointmentDialogState(_parent);
  }
}

class _NewAppointmentDialogState extends State<_NewAppointmentDialog> {
  bool loading = false;
  _DashboardState _parent;

  _NewAppointmentDialogState(this._parent);

  // Checks if an appointment ID exists in the codes file
  bool _documentInCodeFile(String value) {
    return _parent.codeFileState.split(',').contains(value);
  }

  Future<bool> _isCodeInFirestore (String code) async {
    List<String> liveIDs = new List();

    await Queries.appointmentCodes.then((query) {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10.0),
      title: new Text("Enter appointment code"),
      content: SingleChildScrollView(
        child: Form(
          key: _parent._formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child:  TextFormField(
                  controller: _parent.codeController,
                  validator: (value) {
                    if (value.isEmpty){
                      return "Please enter a code";
                    } else {
                      if (_parent.validationResultFile) {
                        return "This appointment is in your calendar";
                      } else {
                        if (_parent.validationResultDb){
                          return null;
                        } else {
                          return "Invalid code";
                        }
                      }
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: RaisedButton(
                          onPressed: () async {
                            if (loading) {
                              return null;
                            }

                            if (_parent.codeController.text.isEmpty){
                              _parent._formKey.currentState.validate();
                            } else {
                              setState(() {
                                loading = true;
                              });

                              bool inFile = _documentInCodeFile(_parent.codeController.text);
                              bool inDatabase = await _isCodeInFirestore(_parent.codeController.text);

                              _parent.validationResultDb = inDatabase;
                              _parent.validationResultFile = inFile;

                              setState(() {
                                loading = false;
                              });

                              if(_parent._formKey.currentState.validate()){
                                _parent.writeData();
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text('SUBMIT'),
                        ),
                      )
                    ),
                    Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: (loading) ? CircularProgressIndicator() : Container(),
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
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

  String dateTimeFormater(DateTime datetime) {
    const List<String> months = [
      "January", "February", "March", "April",
      "May", "June", "July", "August",
      "September", "October", "November", "December"
    ];

    String day = datetime.day.toString();
    String month = months[datetime.month - 1];
    String year = datetime.year.toString();

    return day + " " + month + " " + year;
  }
}

class _CalendarCard extends StatelessWidget {
  final String name;
  final String location;
  final DateTime dateTime;
  final String testID;

  _CalendarCard(this.name, this.location, this.dateTime, this.testID);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child:  Card(
        elevation: 3.0,
        child: Stack(
          children: <Widget>[
            Column(
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
                        Colors.red[400],
                        Colors.yellow[400],
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
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Appointment(name, testID, 0, dateTime))
                      );
                    }),
              ),
            ),
          ],
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