/// This library defines constant classes which interface with the
/// Firebase Cloud Firestore database backend. Each class defines a
/// specific group of queries.

import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

//TODO Remove dependancy on appointment ID here.
// appointmentID needs to be stored with appointment info when added
const String appointmentID = "2vqqyqcc7";

class MessagingQueries {
  static const MessagingQueries _singleton = MessagingQueries._internal();

  factory MessagingQueries() => _singleton;

  const MessagingQueries._internal();

  //TODO Remove appointmentID dependancy!
  static final CollectionReference _colRef = Firestore.instance
      .collection('appointments')
      .document(appointmentID)
      .collection('messages');

  static Stream<QuerySnapshot> get messageSnapshots => _colRef.orderBy('datetime', descending: false).snapshots();

  static void sendMessage(String message, DateTime datetime) {
    _colRef.add({
      'content': message,
      'datetime': datetime,
      'isPatient': true,
      'seenByPatient': true,
      'seenByStaff': false
    });
  }

  static void setSeenByPatient(DocumentReference docRef) {
    docRef.updateData({'seenByPatient': true});
  }
}
