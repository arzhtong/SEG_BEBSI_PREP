import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/widgets/dashboard/calendar_card.dart';
import 'package:prep/widgets/dashboard/calendar_label.dart';

class Calendar extends StatelessWidget {
  String codeFileState;
  List<Map<String, Map<String, dynamic>>> documentList;

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
      List<Map<String, Map<String, dynamic>>> filteredDocuments = new List();

      documentList.forEach((docIdDataMap) {
        String docID = docIdDataMap.keys.first;
        if (_documentInCodeFile(docID)) {
          filteredDocuments.add(docIdDataMap);
        }
      });
      documentList = filteredDocuments;

      String element0docID = documentList.elementAt(0).keys.first;
      Map<String, dynamic> element0dataMap =
          documentList.elementAt(0)[element0docID];

      calendarElements.add(CalendarLabel(element0dataMap['datetime'].toDate()));

      calendarElements.add(CalendarCard(
          element0docID,
          element0dataMap['location'],
          element0dataMap['datetime'].toDate(),
          element0dataMap['testID'],
          element0dataMap['doctor'],
          element0dataMap['testName'],
          element0dataMap['contactNumber']));

      for (int i = 1; i < documentList.length; i++) {
        String prevElementId = documentList.elementAt(i-1).keys.first;
        Map<String, dynamic> prevElementDataMap =
        documentList.elementAt(i-1)[prevElementId];

        String elementidocID = documentList.elementAt(i).keys.first;
        Map<String, dynamic> elementidataMap =
            documentList.elementAt(i)[elementidocID];

        if (_datesAreEqual(elementidataMap['datetime'].toDate(),
            (prevElementDataMap['datetime'].toDate()))) {
          calendarElements.add(CalendarCard(
              elementidocID,
              elementidataMap['location'],
              elementidataMap['datetime'].toDate(),
              elementidataMap['testID'],
              elementidataMap['doctor'],
              elementidataMap['testName'],
              elementidataMap['contactNumber']));
        } else {
          calendarElements
              .add(CalendarLabel(elementidataMap['datetime'].toDate()));
          calendarElements.add(CalendarCard(
              elementidocID,
              elementidataMap['location'],
              elementidataMap['datetime'].toDate(),
              elementidataMap['testID'],
              elementidataMap['doctor'],
              elementidataMap['testName'],
              elementidataMap['contactNumber']));
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
