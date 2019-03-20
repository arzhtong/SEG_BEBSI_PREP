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

class Queries {
  static String appointmentID;
  static String testID;
  static String appointmentName;
  static String location;
  static DateTime dateTime;
  static String doctorName;
  static Color color;

  static const Queries _singleton = Queries._internal();

  factory Queries() => _singleton;

  const Queries._internal();

  static void setAppointmentInfo(newAppointmentID, newTestID,
      newAppointmentName, newLocation, newDateTime, newDoctorName, newColor) {
    appointmentID = newAppointmentID;
    testID = newTestID;
    appointmentName = newAppointmentName;
    location = newLocation;
    dateTime = newDateTime;
    doctorName = newDoctorName;
    color = newColor;
  }

  static Future<QuerySnapshot> get appointmentCodes => _appointmentsCollection
      .where('expired', isEqualTo: false)
      .where('datetime',
          isGreaterThan: DateTime.now().subtract(Duration(days: 1)))
      .orderBy('datetime')
      .getDocuments();

  static DocumentReference get _testReference =>
      DatabaseHandler.db.collection('tests').document(Queries.testID);

  static CollectionReference get _appointmentsCollection =>
      DatabaseHandler.db.collection('appointments');

  static DocumentReference get _appointmentReference =>
      _appointmentsCollection.document(Queries.appointmentID);

  static CollectionReference get _messagesCollection =>
      _appointmentReference.collection('messages');

  static Stream<QuerySnapshot> get messageSnapshots =>
      _messagesCollection.orderBy('datetime', descending: false).snapshots();

  static void sendMessage(String message) => _messagesCollection.add({
        'content': message,
        'datetime': DateTime.now(),
        'isPatient': true,
        'seenByPatient': true,
        'seenByStaff': false,
      });

  static void setSeenByPatient(DocumentReference docRef) =>
      docRef.updateData({'seenByPatient': true});

  static Stream<QuerySnapshot> get dailyCheckupsSnapshots =>
      _appointmentReference
          .collection('dailyCheckups')
          .orderBy('daysBeforeTest', descending: true)
          .snapshots();

  static Stream<QuerySnapshot> get prepCardsSnapshots =>
      _testReference.collection('prepCards').snapshots();

  static Stream<QuerySnapshot> get faqSnapshots => _testReference
      .collection('prepCards')
      .where('type', isEqualTo: 'faqs')
      .snapshots();

  static Stream<DocumentSnapshot> get testSnapshots =>
      _testReference.snapshots();

  static Stream<QuerySnapshot> get recipeSnapshots =>
      _testReference.collection('recipes').snapshots();

  static Stream<DocumentSnapshot> informationSnapshots(documentId) =>
      _testReference.collection('prepCards').document(documentId).snapshots();

  static Stream<DocumentSnapshot> categoryListSnapshots(String documentId) =>
      _testReference.collection('prepCards').document(documentId).snapshots();
}
