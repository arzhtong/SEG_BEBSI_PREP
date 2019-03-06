import 'package:flutter/material.dart';

import 'screens/messaging.screen.dart';

void main() => runApp(Prep());

class Prep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PrepState();
  }
}

class _PrepState extends State<Prep> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new MessagingScreen(),
    );
  }
}