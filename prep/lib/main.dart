import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './screens/dashboard.screen.dart';
import './utils/query.dart';

Future<void> main() async {
  final FirebaseApp firebaseApp = await FirebaseApp.configure(
    name: "Prep",
    options: const FirebaseOptions(
      googleAppID: "1:633103334646:android:c95e32521ac6a78d",
      gcmSenderID: "633103334646",
      apiKey: "AIzaSyBPz3NKdjY8uyYJgZTAc56xg6ncfmMT2cs",
      projectID: "prep-232116",
    ),
  );
  final Firestore firestore = Firestore(app: firebaseApp);
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  MessagingQueries.setFirestoreInstance(firestore);

  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    home: Dashboard(),
  ));
}
