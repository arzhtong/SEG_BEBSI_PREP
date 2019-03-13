import 'package:flutter/material.dart';

import 'package:prep/screens/appointment_info.screen.dart';
import 'package:prep/screens/appointment_prep.screen.dart';
import 'package:prep/screens/daily_checkups.screen.dart';
import 'package:prep/screens/messaging.screen.dart';
import 'package:prep/utils/query.dart';

class Appointment extends StatefulWidget {
  final int index;

  Appointment(appointmentID, testID, this.index) {
    Queries.setAppointmentInfo(appointmentID, testID);
  }

  @override
  State<StatefulWidget> createState() => _AppointmentState(index);
}

class _AppointmentState extends State<Appointment> {
  int _selectedIndex;
  AppointmentInfo _appointmentInfo;
  AppointmentPrep _appointmentPrep;
  DailyCheckups _dailyCheckups;
  MessagingScreen _messagingScreen;

  _AppointmentState(this._selectedIndex);

  Widget getPage(int index) {
    switch(index){
      case 1:
        return (_appointmentPrep != null)
          ? _appointmentPrep
          : _appointmentPrep = AppointmentPrep();
      case 2:
        return (_dailyCheckups != null)
        ? _dailyCheckups
        : _dailyCheckups = DailyCheckups();
      case 3:
        return (_messagingScreen != null)
          ? _messagingScreen
          : _messagingScreen = MessagingScreen();
      default:
        return (_appointmentInfo != null)
          ? _appointmentInfo
          : _appointmentInfo = AppointmentInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("APPOINTMENT SCREEN BUILD METHOD RUN");
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