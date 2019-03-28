import 'package:flutter/material.dart';

import 'package:prep/utils/misc_functions.dart';

class DescriptiveExpansionTile extends StatelessWidget {
  final String category;
  final String description;
  List<Widget> columnChildren;
  final List<dynamic> items;

  DescriptiveExpansionTile(this.category, this.description, this.items) {
    columnChildren = new List();

    if (description != null && description.isNotEmpty) {
      columnChildren.add(
        Text(
          description,
          key: Key('description'),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );

      columnChildren.add(
        Divider(
          color: Colors.transparent,
        ),
      );
    }

    columnChildren.add(Text(
      _formatItemList(items),
      style: TextStyle(
        color: Colors.grey,
      ),
    ));
  }

  String _formatItemList(List<dynamic> elementList) {
    String rawItems = "";

    if (items != null && items.isNotEmpty) {
      elementList.forEach((value) {
        rawItems += value + " " "•" + " ";
      });

      rawItems = rawItems.substring(0, rawItems.length - 3);
    }

    return rawItems;
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
          title: Text(stringValidator(category)),
          children: <Widget>[
            ListTile(
              title: Container(
                key: Key('listContainer'),
                padding: EdgeInsets.only(right: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: columnChildren,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
