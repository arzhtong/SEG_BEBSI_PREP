import 'package:flutter/material.dart';

import 'package:prep/screens/dashboard.screen.dart';
import 'package:prep/utils/query.dart';

void main() {
  DatabaseHandler.initDatabase();

  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    home: Dashboard(),
  ));
}
