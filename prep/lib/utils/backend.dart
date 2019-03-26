/// This library defines constant classes which interface with the
/// Firebase Cloud Firestore database backend. Each class defines a
/// specific group of queries.

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseHandler {
  static Firestore db;

  static const DatabaseHandler _singleton = DatabaseHandler._internal();

  factory DatabaseHandler() => _singleton;

  const DatabaseHandler._internal();

  static void initDatabase() async {
    final FirebaseApp firebaseApp = await FirebaseApp.configure(
      name: "Prep",
      options: FirebaseOptions(
        googleAppID: (Platform.isIOS)
            ? "1:633103334646:ios:c95e32521ac6a78d"
            : "1:633103334646:android:c95e32521ac6a78d",
        gcmSenderID: "633103334646",
        apiKey: "AIzaSyBPz3NKdjY8uyYJgZTAc56xg6ncfmMT2cs",
        projectID: "prep-232116",
      ),
    );
    db = Firestore(app: firebaseApp);
    await db.settings(timestampsInSnapshotsEnabled: true);
  }
}

abstract class BaseBackend {
  String appointmentID;
  String testID;
  String appointmentName;
  String location;
  DateTime dateTime;
  String doctorName;
  String contactNumber;
  Color color;

  void setBackendParams(newAppointmentID, newTestID, newAppointmentName,
      newLocation, newDateTime, newDoctorName, newContactNumber, newColor);

  Future<List<Map<String, Map<String, dynamic>>>> appointmentCodes() async {}

  Stream<List<Map<String, dynamic>>> messagesSnapshots(bool setSeen);

  void sendMessage(String message);

  void flickCheckupSwitch(String documentId, String index, bool previousValue);

  Future<void> setAppointmentCodeUsed(String documentId) async {}

  Stream<List<Map<String, Map<String, dynamic>>>> get dailyCheckupsSnapshots;

  Stream<List<Map<String, Map<String, dynamic>>>> get prepCardsSnapshots;

  Stream<List<Map<String, dynamic>>> get faqSnapshots;

  Stream<Map<String, dynamic>> get testSnapshots;

  Stream<QuerySnapshot> get recipeSnapshots;

  Stream<Map<String, dynamic>> informationSnapshots(String documentId);

  Stream<Map<String, dynamic>> categoryListSnapshots(String documentId);
}

class FirestoreBackend implements BaseBackend {
  String appointmentID;
  String testID;
  String appointmentName;
  String location;
  DateTime dateTime;
  String doctorName;
  String contactNumber;
  Color color;

  static final FirestoreBackend _singleton = FirestoreBackend._internal();

  factory FirestoreBackend() => _singleton;

  FirestoreBackend._internal();

  void setBackendParams(newAppointmentID, newTestID, newAppointmentName,
      newLocation, newDateTime, newDoctorName, newContactNumber, newColor) {
    appointmentID = newAppointmentID;
    testID = newTestID;
    appointmentName = newAppointmentName;
    location = newLocation;
    dateTime = newDateTime;
    doctorName = newDoctorName;
    contactNumber = newContactNumber;
    color = newColor;
  }

  Future<List<Map<String, Map<String, dynamic>>>> appointmentCodes() async {
    QuerySnapshot querySnapshot = await _appointmentsCollection
        .where('expired', isEqualTo: false)
        .where('datetime',
            isGreaterThan: DateTime.now().subtract(Duration(days: 1)))
        .orderBy('datetime')
        .getDocuments();

    List<Map<String, Map<String, dynamic>>> futMap = querySnapshot.documents
        .map((docSnap) => {docSnap.documentID: docSnap.data})
        .toList();

    return futMap;
  }

  DocumentReference get _testReference =>
      DatabaseHandler.db.collection('tests').document(testID);

  CollectionReference get _appointmentsCollection =>
      DatabaseHandler.db.collection('appointments');

  DocumentReference get _appointmentReference =>
      _appointmentsCollection.document(appointmentID);

  CollectionReference get _messagesCollection =>
      _appointmentReference.collection('messages');

  Stream<List<Map<String, dynamic>>> messagesSnapshots(bool setSeen) =>
      _messagesCollection
          .orderBy('datetime', descending: false)
          .snapshots()
          .map((querySnapshot) => querySnapshot.documentChanges
              .map((docChange) {
                if (docChange.type == DocumentChangeType.added) {
                  DocumentSnapshot docSnapshot = docChange.document;
                  Map<String, dynamic> message = docSnapshot.data;
                  if (setSeen && !message['seenByPatient'])
                    docSnapshot.reference.updateData({'seenByPatient': true});
                  return message;
                }
              })
              .where((message) => message != null)
              .toList());

  void sendMessage(String message) => _messagesCollection.add({
        'content': message,
        'datetime': DateTime.now(),
        'isPatient': true,
        'seenByPatient': true,
      });

  void flickCheckupSwitch(String documentId, String index, bool previousValue) {
    _appointmentReference
        .collection('dailyCheckups')
        .document(documentId)
        .updateData({
      // Toggles true/false for the daily checkup
      ('instructions.' + index + '.answer'): !previousValue,
      ('instructions.' + index + '.lastChecked'): DateTime.now(),
    });
  }

  Future<void> setAppointmentCodeUsed(String documentId) async {
    DatabaseHandler.db.runTransaction((transaction) async {
      DocumentSnapshot freshSnap =
          await transaction.get(_appointmentsCollection.document(documentId));
      await transaction.update(freshSnap.reference, {
        'used': true
      });
    });
    //_appointmentsCollection.document(documentId).updateData({'used': true});
  }

  Stream<List<Map<String, Map<String, dynamic>>>> get dailyCheckupsSnapshots =>
      _appointmentReference
          .collection('dailyCheckups')
          .orderBy('daysBeforeTest', descending: true)
          .snapshots()
          .map((querySnap) => querySnap.documents
              .map((docSnap) => {docSnap.documentID: docSnap.data})
              .toList());

  Stream<List<Map<String, Map<String, dynamic>>>> get prepCardsSnapshots =>
      _testReference.collection('prepCards').snapshots().map((querySnap) =>
          querySnap.documents
              .map((docSnap) => {docSnap.documentID: docSnap.data})
              .toList());

  Stream<List<Map<String, dynamic>>> get faqSnapshots => _testReference
      .collection('prepCards')
      .where('type', isEqualTo: 'faqs')
      .snapshots()
      .map((querySnap) =>
          querySnap.documents.map((docSnap) => docSnap.data).toList());

  Stream<Map<String, dynamic>> get testSnapshots =>
      _testReference.snapshots().map((docSnap) => docSnap.data);

  Stream<QuerySnapshot> get recipeSnapshots => _testReference
      .collection('prepCards')
      .where('cardType', isEqualTo: 'recipe')
      .snapshots();

  Stream<Map<String, dynamic>> informationSnapshots(documentId) =>
      _testReference
          .collection('prepCards')
          .document(documentId)
          .snapshots()
          .map((docSnap) => docSnap.data);

  Stream<Map<String, dynamic>> categoryListSnapshots(String documentId) =>
      _testReference
          .collection('prepCards')
          .document(documentId)
          .snapshots()
          .map((docSnap) => docSnap.data);
}
