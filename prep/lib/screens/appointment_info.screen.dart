import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:prep/utils/query.dart';

class AppointmentInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppointmentInfoState();
}

class _AppointmentInfoState extends State<AppointmentInfo> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return Container(
        child: SingleChildScrollView(
          child: Html(
            data: document['description'],
            padding: EdgeInsets.all(20.0),
            useRichText: true,  //turn this off to get the alternative parser
            onLinkTap: (url){
              //TODO: decide how to handle hyperlinks in the HTML
              print("Handling links");
            },
            customRender: null,
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Queries.testSnapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(),);
        return _buildListItem(context, snapshot.data);
      }
    );
  }
}