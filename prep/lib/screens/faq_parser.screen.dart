import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/widgets/faq_parser/faq_expansion_tile.dart';

class FaqParser extends StatelessWidget {
  Widget _buildListItem(BuildContext context, Map<String, dynamic> dataMap) {
    return FaqExpansionTile(dataMap['question'], dataMap['answer'],
        dataMap['chatShortcut'], dataMap['informationShortcut']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("FAQ"),
      ),
      body: StreamBuilder(
        stream: BackendProvider.of(context).backend.faqSnapshots,
        builder: (context, mapListSnapshot) {
          if (!mapListSnapshot.hasData) {
            return const Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            );
          } else {
            print("-------THE NEW DATA IS-----------");
            print(mapListSnapshot.data);
            if (mapListSnapshot.data != null &&
                mapListSnapshot.data.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: mapListSnapshot.data.length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, mapListSnapshot.data[index]),
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
