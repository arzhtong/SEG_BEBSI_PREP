import 'package:flutter/material.dart';
import './screens/dashboard.screen.dart';

void main() => runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Dashboard(),
    )
);