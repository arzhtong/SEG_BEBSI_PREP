import 'package:flutter/material.dart';

import 'package:prep/screens/appointment_info.screen.dart';
import 'package:prep/screens/appointment_prep.screen.dart';
import 'package:prep/screens/daily_checkups.screen.dart';
import 'package:prep/screens/messaging.screen.dart';

class Appointment extends StatefulWidget {
  final String _appointmentID;
  final String _testID;
  Appointment(this._appointmentID, this._testID);

  @override
  State<StatefulWidget> createState() {
    print("Appointment screen recieved: " + _appointmentID);
    return _AppointmentState();
  }
}

class _AppointmentState extends State<Appointment> {
  int _selectedIndex = 0;
  AppointmentInfo _appointmentInfo;
  AppointmentPrep _appointmentPrep;
  DailyCheckups _dailyCheckups;
  MessagingScreen _messagingScreen;

  Widget getPage(int index) {
    switch(index){
      case 1:
        return (_appointmentPrep != null)
          ? _appointmentPrep
          : _appointmentPrep = AppointmentPrep();
      case 2:
        return (_dailyCheckups != null)
        ? _dailyCheckups
        : _dailyCheckups = DailyCheckups(widget._appointmentID);
      case 3:
        return (_messagingScreen != null)
          ? _messagingScreen
          : _messagingScreen = MessagingScreen(widget._appointmentID);
      default:
        return (_appointmentInfo != null)
          ? _appointmentInfo
          : _appointmentInfo = AppointmentInfo(widget._testID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Appointments'),
      ),
      body: Center(
        child: getPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.update), title: Text('Information')),
          BottomNavigationBarItem(icon: Icon(Icons.accessibility_new), title: Text('Preparation')),
          BottomNavigationBarItem(icon: Icon(Icons.done_all), title: Text('Checkups')),
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('Dr. Chat')),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        fixedColor: Colors.indigo,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
}