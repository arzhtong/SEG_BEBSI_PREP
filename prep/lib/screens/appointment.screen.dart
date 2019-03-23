import 'package:flutter/material.dart';

import 'package:prep/screens/appointment_info.screen.dart';
import 'package:prep/screens/appointment_prep.screen.dart';
import 'package:prep/screens/daily_checkups.screen.dart';
import 'package:prep/screens/messaging.screen.dart';
import 'package:prep/utils/query.dart';
import 'package:prep/widgets/dashboard/help_dialog.dart';

class Appointment extends StatefulWidget {
  final int index;

  Appointment(this.index);

  @override
  State<StatefulWidget> createState() => _AppointmentState(index);
}

class _AppointmentState extends State<Appointment> {
  bool _unseenMessages = false;
  int _selectedIndex;
  AppointmentInfo _appointmentInfo;
  AppointmentPrep _appointmentPrep;
  DailyCheckups _dailyCheckups;
  MessagingScreen _messagingScreen;

  _AppointmentState(this._selectedIndex);

  Widget _getPage(int index) {
    switch (index) {
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

  Widget _chooseHelpMenuToDisplay() {
    switch (_selectedIndex) {
      case 0:
        {
          return MakeHelpIcon(
              'This page offers relevant information about your appointment.');
        }
      case 1:
        {
          return MakeHelpIcon(
              'This page contains all the preparation information your doctor has provided for your appointment.');
        }
      case 2:
        {
          return MakeHelpIcon(
              "Let your doctor know how well you're preparing for your appointment by checking the daily instructions.");
        }
      case 3:
        {
          return MakeHelpIcon(
              "Chat directly with your doctor about pressing issues.");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(FirestoreBackend().appointmentName),
          actions: <Widget>[_chooseHelpMenuToDisplay()]),
      body: Center(
        child: _getPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.info), title: Text('Information')),
          BottomNavigationBarItem(
              icon: Icon(Icons.sort), title: Text('Preparation')),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_attributes), title: Text('Checkups')),
          BottomNavigationBarItem(
              icon: _buildChatIcon(), title: Text('Dr. Chat')),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        fixedColor: Colors.indigo,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildChatIcon() {
    return (_selectedIndex == 3)
        ? Icon(Icons.chat)
        : StreamBuilder(
            stream: FirestoreBackend().messageSnapshots,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                snapshot.data.documentChanges.forEach((change) {
                  if (change.type == DocumentChangeType.added &&
                      !change.document.data['seenByPatient']) {
                    _unseenMessages = true;
                  }
                });
              }
              return (_unseenMessages)
                  ? Icon(Icons.chat, color: Colors.red)
                  : Icon(Icons.chat);
            },
          );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 3) _unseenMessages = false;
    });
  }
}
