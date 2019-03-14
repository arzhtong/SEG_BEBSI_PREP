import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prep/screens/dashboard.screen.dart';
import 'package:prep/utils/query.dart';

void main() {
  DatabaseHandler.initDatabase();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Dashboard(),
    ));
  });
}
