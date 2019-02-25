import 'package:flutter/material.dart';

import 'package:prep/screens/appointment_info.screen.dart';
import 'package:prep/screens/appointment_prep.screen.dart';
import 'package:prep/screens/daily_checkups.screen.dart';
import 'package:prep/screens/messaging.screen.dart';
import 'package:prep/main.dart';

class Appointment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppointmentState();
  }
}

class _AppointmentState extends State<Appointment> {
  int _selectedIndex = 0;

  final _widgetOptions = [
    AppointmentInfo(),
    AppointmentPrep(),
    DailyCheckups(),
    Messaging()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Appointments'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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