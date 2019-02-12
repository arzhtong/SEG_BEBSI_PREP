import 'package:flutter/material.dart';

import './appointment_prep.dart';
import './daily_checkups.dart';
import './messaging.dart';

class AppointmentInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppointmentInfoState();
  }
}

class _AppointmentInfoState extends State<AppointmentInfo> {
  int _selectedIndex = 0;

  final _widgetOptions = [
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