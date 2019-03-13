/// This library defines constant classes which interface with the
/// Firebase Cloud Firestore database backend. Each class defines a
/// specific group of queries.

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

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

  static const Queries _singleton = Queries._internal();

  factory Queries() => _singleton;

  const Queries._internal();

  static void setAppointmentInfo(newAppointmentID, newTestID) {
    appointmentID = newAppointmentID;
    testID = newTestID;
  }

  static DocumentReference get _testReference => DatabaseHandler.db
      .collection('tests')
      .document(Queries.testID);

  static DocumentReference get _appointmentReference => DatabaseHandler.db
      .collection('appointments')
      .document(Queries.appointmentID);

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

  static Stream<QuerySnapshot> get faqSnapshots =>
      _testReference.collection('faqs').snapshots();

  static Stream<DocumentSnapshot> get testSnapshots =>
      _testReference.get().asStream();

  static Stream<DocumentSnapshot> informationSnapshots(documentName) =>
      _testReference
          .collection('informations')
          .document(documentName)
          .get()
          .asStream();
}