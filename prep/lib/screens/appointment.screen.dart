import 'package:flutter/material.dart';

import 'package:prep/screens/appointment_info.screen.dart';
import 'package:prep/screens/appointment_prep.screen.dart';
import 'package:prep/screens/daily_checkups.screen.dart';
import 'package:prep/screens/messaging.screen.dart';

class Appointment extends StatefulWidget {
  final String _appointmentID;
  Appointment(this._appointmentID);

  @override
  State<StatefulWidget> createState() {
    print("Appointment screen recieved: " + _appointmentID);
    return _AppointmentState();
  }
}

class _AppointmentState extends State<Appointment> {
  int _selectedIndex = 0;

  Widget getPage(int index) {
    switch(index){
      case 0: {return AppointmentInfo();}
      break;
      case 1: {return AppointmentPrep();}
      break;
      case 2: {return DailyCheckups(widget._appointmentID);}
      break;
      default: {return Messaging();}
      break;
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
          BottomNavigationBarItem(icon: Icon(Icons.done_all), title: Text('Daily Ceckups')),
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