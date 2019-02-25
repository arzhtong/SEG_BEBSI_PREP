import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import './appointment.screen.dart';

class DailyCheckups extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DailyCheckups();
  }
}

class _DailyCheckups extends State<DailyCheckups> {
  @override
  Widget build(BuildContext context) {
    return Text("Daily checkups");
  }
}