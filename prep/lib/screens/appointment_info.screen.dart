import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './appointment.screen.dart';

class AppointmentInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppointmentInfoState();
  }
}

class _AppointmentInfoState extends State<AppointmentInfo> {
  @override
  Widget build(BuildContext context) {
    return Text("Appointment info");
  }
}