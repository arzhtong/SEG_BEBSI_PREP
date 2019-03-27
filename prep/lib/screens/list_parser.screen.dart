import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/backend_provider.dart';
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
          stream: BackendProvider.of(context)
              .backend
              .categoryListSnapshots(documentId),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(),
              );
            } else {
              if (dataSnapshot.data['maps'] != null &&
                  dataSnapshot.data['maps'].length > 0) {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: 1,
                  itemBuilder: (context, index) =>
                      _buildDropDownList(context, dataSnapshot.data),
                );
              } else {
                return EmptyScreenPlaceholder("No items in this list", "");
              }
            }
          }),
    );
  }

  Widget _buildDropDownList(
      BuildContext context, Map<String, dynamic> dataMap) {
    List<Widget> dropDowns = new List();
    List<dynamic> mappedData = dataMap['maps'];

    mappedData.forEach((value) {
      dropDowns.add(DescriptiveExpansionTile(
          value['name'], value['description'], value['list']));
    });

    return Column(key: Key("listsColumn"), children: dropDowns);
  }
}
