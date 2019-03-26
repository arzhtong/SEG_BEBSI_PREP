import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:prep/screens/appointment.screen.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/misc_functions.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/widgets/dashboard/calendar_card.dart';
import 'package:prep/widgets/dashboard/calendar_label.dart';

class Calendar extends StatelessWidget {
  String codeFileState;
  List<DocumentSnapshot> documentList;

  Calendar(this.codeFileState, this.documentList);

  bool _documentInCodeFile(String value) {
    return codeFileState.split(',').contains(value);
  }

  bool _datesAreEqual(DateTime date1, DateTime date2) {
    return (date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year);
  }

  @override
  Widget build(BuildContext context) {
    // building the return widget based on the updated (current) codes file
    List<Widget> calendarElements = new List();

    if (codeFileState == null) {
      return null;
    } else if (codeFileState.isEmpty) {
      return EmptyScreenPlaceholder(
          "Your calendar is empty", "Add some appointments");
    } else {
      //Generates a list of filtered appointments
      List<DocumentSnapshot> filteredDocuments = new List();
      documentList.forEach((doc) {
        if (_documentInCodeFile(doc.documentID)) {
          filteredDocuments.add(doc);
        }
      });
      documentList = filteredDocuments;

      calendarElements.add(
          CalendarLabel(documentList.elementAt(0).data['datetime'].toDate()));
      calendarElements.add(CalendarCard(
          documentList.elementAt(0).documentID,
          documentList.elementAt(0).data['location'],
          documentList.elementAt(0).data['datetime'].toDate(),
          documentList.elementAt(0).data['testID'],
          documentList.elementAt(0).data['doctor'],
          documentList.elementAt(0).data['testName']));

      for (int i = 1; i < documentList.length; i++) {
        if (_datesAreEqual(documentList.elementAt(i).data['datetime'].toDate(),
            (documentList.elementAt(i - 1).data['datetime'].toDate()))) {
          calendarElements.add(CalendarCard(
              documentList.elementAt(i).documentID,
              documentList.elementAt(i).data['location'],
              documentList.elementAt(i).data['datetime'].toDate(),
              documentList.elementAt(i).data['testID'],
              documentList.elementAt(i).data['doctor'],
              documentList.elementAt(i).data['testName']));
        } else {
          calendarElements.add(CalendarLabel(
              documentList.elementAt(i).data['datetime'].toDate()));
          calendarElements.add(CalendarCard(
              documentList.elementAt(i).documentID,
              documentList.elementAt(i).data['location'],
              documentList.elementAt(i).data['datetime'].toDate(),
              documentList.elementAt(i).data['testID'],
              documentList.elementAt(i).data['doctor'],
              documentList.elementAt(i).data['testName']));
        }
      }

      return ListView(
        padding:
        EdgeInsets.only(top: 10.0, bottom: 80.0, left: 10.0, right: 10.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: calendarElements,
          )
        ],
      );
    }
  }
}