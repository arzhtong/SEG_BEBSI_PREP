import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prep/utils/query.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/widgets/faq_parser/faq_expansion_tile.dart';

class FaqParser extends StatelessWidget {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return FaqExpansionTIle(document['question'], document['answer'],
        document['chatShortcut'], document['informationShortcut']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("FAQ"),
      ),
      body: StreamBuilder(
        //stream: Queries.faqSnapshots,
        stream: Firestore.instance
            .collection('tests')
            .document(Queries.testID)
            .collection('prepCards').where('type', isEqualTo: 'faqs')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            );
          } else {
            if (snapshot.data.documents != null &&
                snapshot.data.documents.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]),
              );
            } else {
              return EmptyScreenPlaceholder(
                  "There are no FAQs", "Contact your doctor for help");
            }
          }
        },
      ),
    );
  }
}
