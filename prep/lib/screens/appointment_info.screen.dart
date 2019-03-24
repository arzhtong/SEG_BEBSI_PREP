import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/widgets/appointment_info/appointment_banner.dart';
import 'package:prep/utils/misc_functions.dart';

class AppointmentInfo extends StatelessWidget {
  Widget _buildListItem(BuildContext context, Map<String, dynamic> dataMap) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Html(
            data: dataMap['description'],
            useRichText: true,
            //turn this off to get the alternative parser
            onLinkTap: (url) {
              launchURL(url);
            },
            customRender: null,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        AppointmentDetailsBanner(),
        StreamBuilder(
            stream: BackendProvider.of(context).backend.testSnapshots,
            builder: (context, dataSnapshot) {
              if (!dataSnapshot.hasData) {
                return const Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(),
                );
              } else {
                if (dataSnapshot.data['description'] != null &&
                    dataSnapshot.data['description'].length > 0) {
                  return _buildListItem(context, dataSnapshot.data);
                } else {
                  return Container(
                      padding: EdgeInsets.only(top: 50.0),
                      child: EmptyScreenPlaceholder(
                          "This article contains no more information", ""));
                }
              }
            }),
      ],
    );
  }
}
