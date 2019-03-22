import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prep/utils/query.dart';
import 'package:prep/widgets/list_parser/description_expansion_tile.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';

class CategoryListParser extends StatelessWidget {
  final String documentId;
  final String _title;

  CategoryListParser(this.documentId, this._title);

  Widget build(BuildContext context) {
    print("DocumentID: " + documentId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(_title),
      ),
      body: StreamBuilder(
          stream: Queries.categoryListSnapshots(documentId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(),
              );
            } else {
              if (snapshot.data['maps'] != null &&
                  snapshot.data['maps'].length > 0) {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: 1,
                  itemBuilder: (context, index) =>
                      _buildDropDownList(context, snapshot.data),
                );
              } else {
                return EmptyScreenPlaceholder("No items in this list", "");
              }
            }
          }),
    );
  }

  Widget _buildDropDownList(BuildContext context, DocumentSnapshot document) {
    List<Widget> dropDowns = new List();
    List<dynamic> mappedData = document['maps'];

    print(document['maps']);

    mappedData.forEach((value) {
      dropDowns.add(DescriptiveExpansionTile(
          value['name'], value['description'], value['list']));
    });

    return Column(children: dropDowns);
  }
}
