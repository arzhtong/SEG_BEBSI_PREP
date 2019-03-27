import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/widgets/dashboard/help_dialog.dart';
import 'package:prep/widgets/dashboard/calendar.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  // Firestore variables
  Widget cachedCalendar;
  List<Map<String, Map<String, dynamic>>> documentList;

  // Codes file variables
  String codeFileState;

  // Form validation variables
  TextEditingController codeController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool validationResultDb;
  bool validationResultFile;

  // Subscribe user to message notifications
  void _subscribeToNotifications(String appointmentID) {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.autoInitEnabled();
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
  Future<File> _clearData() async {
    _unsubscribeFromNotifications();
    //must apply set state to make sure the calendar is redrawn
    setState(() {
      codeFileState = "";
      codeController.text = '';
    });
    return BackendProvider.of(context).storage.writeData("");
  }

  // Checks if a code exists in the Firestore and is not used
  Future<bool> _isCodeInFirestoreNotUsed(String code) async {
    List<String> liveNotUsedIDs = new List();

    await BackendProvider.of(context).backend.appointmentCodes().then((query) {
      query.forEach((dataListMap) {
        String docId = dataListMap.keys.first;
        if (dataListMap[docId]['used'] == false) {
          liveNotUsedIDs.add(docId);
        }
      });
    });

    if (liveNotUsedIDs.contains(code)) {
      return true;
    } else {
      return false;
    }
  }

  // Retrieves data from the Firestore and builds the calendar
  Future<Widget> _getDocData() async {
    bool fileExists = await BackendProvider.of(context).storage.fileExists();

    if (fileExists) {
      print("--- codes file found!");
    } else {
      print("--- codes file NOT found, creating one containing ','");
      await BackendProvider.of(context).storage.writeData(",");
    }

    codeFileState = await BackendProvider.of(context).storage.readData();
    print("Raw codes file - in getDocData after reading: " + codeFileState);

    //reading appointments from the database and updating the codes file
    var querySnap =
        await BackendProvider.of(context).backend.appointmentCodes();

    if (querySnap == null) {
      return EmptyScreenPlaceholder(
          "Your calendar is empty", "Add some appointments");
    }

    documentList = querySnap;

    // Get all the codes stored in the database
    List<String> availableCodes = new List();

    documentList.forEach((docIdDataMap) {
      availableCodes.add(docIdDataMap.keys.first);
    });

    print("Available codes:" + availableCodes.toString());

    // Store all the codes in both the database and the codes file in the var
    String newCodeFileState = "";

    codeFileState.split(',').forEach((code) {
      if (availableCodes.contains(code)) {
        newCodeFileState = newCodeFileState + code + ',';
      }
    });

    print("New codes files - after filtering: " + newCodeFileState);

    // Saving the new sequence of codes in the codes file and updating file state
    await BackendProvider.of(context).storage.writeData(newCodeFileState);
    codeFileState = newCodeFileState;

    // building the return widget based on the updated (current) codes file
    return Calendar(codeFileState, documentList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Calendar"),
        actions: <Widget>[
          MakeHelpIcon(
              'This screen shows a calendar with all your due appointments. Tap on one of them to get more information.'),
          IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () {
                print("---clear data button pressed---");
                _clearData();
              }),
          IconButton(
              key: Key('refreshButton'),
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      body: FutureBuilder(
          future: _getDocData(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            print("Snapshot: " + snapshot.data.toString());
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
                          print("--------SUBMIT button pressed");
                          if (loading) {
                            return null;
                          }

                          print("Checkpoint 1");

                          if (_parent.codeController.text.isEmpty) {
                            _parent._formKey.currentState.validate();
                          } else {
                            setState(() {
                              loading = true;
                            });

                            print("Checkpoint 2");

                            bool inFile = _parent._documentInCodeFile(
                                _parent.codeController.text);
                            bool inDatabase =
                                await _parent._isCodeInFirestoreNotUsed(
                                    _parent.codeController.text);

                            // The validator will succeed if the code is not already in the codes file and if it is not used in firestore
                            _parent.validationResultDb = inDatabase;
                            _parent.validationResultFile = inFile;

                            print("Checkpoint 3");

                            // If the validator will succeed, start overwriting the used field already
                            if (inDatabase && !inFile) {
                              await BackendProvider.of(context)
                                  .backend
                                  .setAppointmentCodeUsed(
                                      _parent.codeController.text);
                              print(
                                  "-----------TRANSITION COMPLETED----------");
                            }

                            print("Checkpoint 4");

                            setState(() {
                              loading = false;
                            });

                            print("Checkpoint 5");

                            if (_parent._formKey.currentState.validate()) {
                              await BackendProvider.of(context)
                                  .storage
                                  .writeData(_parent.codeFileState +
                                      _parent.codeController.text +
                                      ',');

                              _parent.setState(() {
                                _parent._subscribeToNotifications(
                                    _parent.codeController.text);
                                _parent.codeController.text = "";
                              });

                              print("--------- Navigator about to pop");

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
