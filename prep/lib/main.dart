import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prep/screens/dashboard.screen.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/backend.dart';

void main() {
  DatabaseHandler.initDatabase();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        BackendProvider(
          backend: FirestoreBackend(),
          child: MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),
            home: Dashboard(),
          ),
        ),
      );
    },
  );
}
