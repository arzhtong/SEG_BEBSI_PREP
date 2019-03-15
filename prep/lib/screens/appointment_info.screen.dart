import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

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
            padding: EdgeInsets.all(10.0),
            useRichText: true,  //turn this off to get the alternative parser
            onLinkTap: (url){
              _launchURL(url);
            },
            customRender: null,
          ),
        )
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cloud not launch url';
    }
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