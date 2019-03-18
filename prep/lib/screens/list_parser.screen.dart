import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prep/utils/query.dart';
import 'package:prep/widgets/list_parser/description_expansion_tile.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/utils/help_screen.dart';

class CategoryListParser extends StatelessWidget {
  final String _contents;
  final String _categoryName;

  CategoryListParser(this._contents, this._categoryName);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(_categoryName),
      ),
      body: StreamBuilder(
          stream: Queries.categoryListSnapshots(_contents),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(),
              );
            } else {
              if (snapshot.data['maps'].length > 0) {
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

    mappedData.forEach((value) {
      dropDowns.add(DescriptiveExpansionTile(
          value['name'], value['description'], value['list']));
    });

    return Column(children: dropDowns);
  }
}
