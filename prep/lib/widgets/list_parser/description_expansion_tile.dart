import 'package:flutter/material.dart';

class DescriptiveExpansionTile extends StatelessWidget {
  final String category;
  final String description;
  List<Widget> columnChildren;
  final List<dynamic> items;

  DescriptiveExpansionTile(this.category, this.description, this.items) {
    columnChildren = new List();

    if (description.isNotEmpty) {
      columnChildren.add(
        Text(
          description,
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
      formatItemList(items),
      style: TextStyle(
        color: Colors.grey,
      ),
    ));
  }

  String formatItemList(List<dynamic> elementList) {
    String rawItems = "";

    if (items.isNotEmpty) {
      elementList.forEach((value) {
        rawItems += value + " " "•" + " ";
      });

      rawItems =
          rawItems.replaceRange(rawItems.length - 2, rawItems.length - 1, ' ');
    }

    return rawItems;
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
          title: Text(category),
          children: <Widget>[
            ListTile(
              title: Container(
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
