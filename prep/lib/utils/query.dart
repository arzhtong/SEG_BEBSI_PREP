/// This library defines constant classes which interface with the
/// Firebase Cloud Firestore database backend. Each class defines a
/// specific group of queries.

import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

//TODO Remove dependancy on appointment ID here.
// appointmentID needs to be stored with appointment info when added

class MessagingQueries {
  static String _appointmentID;
  static CollectionReference _colRef;

  static const MessagingQueries _singleton = MessagingQueries._internal();

  factory MessagingQueries() => _singleton;

  const MessagingQueries._internal();

  static Stream<QuerySnapshot> get messageSnapshots =>
      _colRef.orderBy('datetime', descending: false).snapshots();

  static void setAppointmentID(String appointmentID) {
    _appointmentID = appointmentID;

    _colRef = Firestore.instance
        .collection('appointments')
        .document(_appointmentID)
        .collection('messages');
  }

  static void sendMessage(String message, DateTime datetime) => _colRef.add({
        'content': message,
        'datetime': datetime,
        'isPatient': true,
        'seenByPatient': true,
        'seenByStaff': false
      });

  static void setSeenByPatient(DocumentReference docRef) =>
      docRef.updateData({'seenByPatient': true});
}
