import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prep/utils/query.dart';

class CategoryListParser extends StatefulWidget{
  final String _contents;
  
  CategoryListParser(this._contents);

  @override
  State<StatefulWidget> createState() {
    return _CategoryListState();
  }
}

class _CategoryListState extends State<CategoryListParser>{
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Appointments'),
      ),
        body: StreamBuilder(
        stream: Queries.categoryListSnapshots(widget._contents),
        builder: (context, snapshot){
          if (!snapshot.hasData) return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(),);
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: 1,
            itemBuilder: (context, index) => _buildDropDownList(context,snapshot.data)
          );
        }
      ),
    );
  }

  Widget _buildDropDownList(BuildContext context, DocumentSnapshot document){
    List<Widget> dropDowns = new List();
    List<dynamic> mappedData = document['maps'];

    mappedData.forEach((value){
      dropDowns.add(DescriptiveExpansionTile(value['name'], value['description'], value['list']));
    });

    return Column(
      children: dropDowns
    );
  }
}

class DescriptiveExpansionTile extends StatelessWidget {
  final String category;
  final String description;
  List<Widget> columnChildren;
  final List<dynamic> items;

  DescriptiveExpansionTile(this.category,this.description,this.items){
    columnChildren = new List();

    if (description.isNotEmpty){
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

    columnChildren.add(
      Text(
        formatItemList(items),
        style: TextStyle(
          color: Colors.grey,
        ),
      )
    );
  }

  String formatItemList(List<dynamic> elementList){
    String rawItems = "";

    elementList.forEach((value){
      rawItems += value + " " "•" + " ";
    });

    rawItems = rawItems.replaceRange(rawItems.length - 2, rawItems.length - 1,' ');

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