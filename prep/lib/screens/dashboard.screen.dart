import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:prep/widgets/dashboard/calendar_label.dart';
import 'package:prep/widgets/dashboard/calendar_card.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/utils/storage.dart';
import 'package:prep/utils/query.dart';
import 'package:prep/utils/help_screen.dart';
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

  // TODO: replace the calling of this method.
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
  Future<File> clearData() async {
    _unsubscribeFromNotifications();
    //must apply set state to make sure the calendar is redrawn
    setState(() {
      codeFileState = "";
      codeController.text = '';
    });
    return storage.writeData("");
  }

//  // Checks if a code exists in the Firestore
  Future<bool> _isCodeInFirestore(String code) async {
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
    bool fileExists = await storage.fileExists();

    if (fileExists) {
      print("--- codes file found!");
    } else {
      print("--- codes file NOT found, creating one containing ','");
      await storage.writeData(",");
    }

    codeFileState = await storage.readData();
    print("Raw codes file - in getDocData after reading: " + codeFileState);

    //reading appointments from the database and updating the codes file
    documentList = new List();
    testDocList = await Queries.appointmentCodes;
    documentList = testDocList.documents;

    // Get all the codes stored in the database
    List<String> documentIDs = new List();
    documentList.forEach((doc) {
      documentIDs.add(doc.documentID);
    });

    // Store all the codes in both the database and the codes file in the var
    String newCodeFileState = "";
    codeFileState.split(',').forEach((code) {
      if (documentIDs.contains(code)) {
        newCodeFileState = newCodeFileState + code + ',';
      }
    });

    print("New codes files - after filtering: " + newCodeFileState);

    // Saving the new sequence of codes in the codes file
    await storage.writeData(newCodeFileState);

    codeFileState = newCodeFileState;

    // building the return widget based on the updated (current) codes file
    return _buildCalendarWidget();
  }

  bool _datesAreEqual(DateTime date1, DateTime date2) {
    return (date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year);
  }

  Widget _buildCalendarWidget() {
    // building the return widget based on the updated (current) codes file
    List<Widget> calendarElements = new List();

    if (codeFileState == null) {
      return null;
    } else if (codeFileState.isEmpty) {
      return EmptyScreenPlaceholder("Your calendar is empty", "Add some appointments");
    } else {
      //Generates a list of filtered appointments
      List<DocumentSnapshot> filteredDocuments = new List();
      documentList.forEach((doc) {
        if (_documentInCodeFile(doc.documentID)) {
          filteredDocuments.add(doc);
        }
      });
      documentList = filteredDocuments;

      calendarElements.add(
          CalendarLabel(documentList.elementAt(0).data['datetime'].toDate()));
      calendarElements.add(CalendarCard(
          documentList.elementAt(0).documentID,
          documentList.elementAt(0).data['location'],
          documentList.elementAt(0).data['datetime'].toDate(),
          documentList.elementAt(0).data['testID'],
          documentList.elementAt(0).data['doctor'],
          documentList.elementAt(0).data['testName']));

      for (int i = 1; i < documentList.length; i++) {
        if (_datesAreEqual(documentList.elementAt(i).data['datetime'].toDate(),
            (documentList.elementAt(i - 1).data['datetime'].toDate()))) {
          calendarElements.add(CalendarCard(
              documentList.elementAt(i).documentID,
              documentList.elementAt(i).data['location'],
              documentList.elementAt(i).data['datetime'].toDate(),
              documentList.elementAt(i).data['testID'],
              documentList.elementAt(i).data['doctor'],
              documentList.elementAt(i).data['testName']));
        } else {
          calendarElements.add(CalendarLabel(
              documentList.elementAt(i).data['datetime'].toDate()));
          calendarElements.add(CalendarCard(
              documentList.elementAt(i).documentID,
              documentList.elementAt(i).data['location'],
              documentList.elementAt(i).data['datetime'].toDate(),
              documentList.elementAt(i).data['testID'],
              documentList.elementAt(i).data['doctor'],
              documentList.elementAt(i).data['testName']));
        }
      }

      return ListView(
        padding:
        EdgeInsets.only(top: 10.0, bottom: 80.0, left: 10.0, right: 10.0),
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
        title: Text("Calendar"),
        actions: <Widget>[
          MakeHelpIcon('This is a page used to give basic information regarding the scan'),
          IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () {
                print("---clear data button pressed---");
                clearData();
              }),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      body: FutureBuilder(
          future: _getDocData(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return (cachedCalendar == null)
                    ? LinearProgressIndicator()
                    : Stack(children: <Widget>[
                        cachedCalendar,
                        LinearProgressIndicator()
                      ]);
              default:
                cachedCalendar = snapshot.data;
                return snapshot.data;
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            print("floating button pressed - codeFileState: " + codeFileState);
            showDialog(
                context: context, builder: (_) => _NewAppointmentDialog(this));
          }),
    );
  }
}

class _NewAppointmentDialog extends StatefulWidget {
  final _DashboardState _parent;

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
                child: TextFormField(
                  controller: _parent.codeController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a code";
                    } else {
                      if (_parent.validationResultFile) {
                        return "This appointment is in your calendar";
                      } else {
                        if (_parent.validationResultDb) {
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
                        color: Colors.indigo,
                        onPressed: () async {
                          if (loading) {
                            return null;
                          }

                          if (_parent.codeController.text.isEmpty) {
                            _parent._formKey.currentState.validate();
                          } else {
                            setState(() {
                              loading = true;
                            });

                            bool inFile = _parent._documentInCodeFile(
                                _parent.codeController.text);
                            bool inDatabase = await _parent._isCodeInFirestore(
                                _parent.codeController.text);

                            _parent.validationResultDb = inDatabase;
                            _parent.validationResultFile = inFile;

                            setState(() {
                              loading = false;
                            });

                            if (_parent._formKey.currentState.validate()) {
                              print(
                                  "To be new code test file - NEW CODE DIALOG");

                              await _parent.storage.writeData(
                                  _parent.codeFileState +
                                      _parent.codeController.text +
                                      ',');

                              _parent.setState(() {
                                _parent.codeController.text = "";
                              });

                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child:
                          (loading) ? CircularProgressIndicator() : Container(),
                    ))
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
