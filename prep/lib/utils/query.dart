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

  static final Stream<QuerySnapshot> _snapshots =
      _colRef.orderBy('datetime', descending: true).snapshots();

  Stream<QuerySnapshot> get messagesSnapshots => _snapshots;


  void sendMessage(String message, DateTime datetime) {
    _colRef.add({
      'content': message,
      'datetime': datetime,
      'isPatient': true,
      'seenByPatient': true,
      'seenByStaff': false
    });
  }

  void setSeenByPatient(DocumentReference docRef) {
    // WriteBatch batch = Firestore.instance.batch();
    // _colRef.getDocuments().then((querySnapshot) => {
    //   querySnapshot.documents.forEach((doc) => {
    //     batch.updateData(doc.reference, { 'seenByPatient': true })
    //   }),
    //   batch.commit()
    // });
    docRef.updateData({'seenByPatient': true});
  }
}
