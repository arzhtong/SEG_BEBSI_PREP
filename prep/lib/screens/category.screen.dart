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
    print("Contents received in category state: X" + widget._contents + "X");
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
  print(document['maps']);

  List<dynamic> mappedData = document['maps'];

  mappedData.forEach((value){
    dropDowns.add(DescriptiveExpansionTile(value['name'], value['description'], value['list']));
  });

  return Column(
    children: dropDowns
  );
   }
}
class DescriptiveExpansionTile extends StatefulWidget {
  String category;
  String description;
  List<Widget> columnChildren;
  List<dynamic> items;
 State<StatefulWidget> createState() {
    
    return _DescriptiveExpansionTileState();
  }
  DescriptiveExpansionTile(this.category,this.description,this.items){
    columnChildren=new List();
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
          color: Colors.white,
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
   String formatItemList(List<dynamic> elementlist){
    String rawItems="";

    elementlist.forEach((value){
      rawItems+=value + " " "•" + " ";
    });

    rawItems=rawItems.replaceRange(rawItems.length-2,rawItems.length-1,' ');
    return rawItems;
  }
}
 

 class _DescriptiveExpansionTileState extends State<DescriptiveExpansionTile>{
    Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
          title: Text(widget.category),
          children: <Widget>[
            ListTile(
              //contentPadding: EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 0.0),
              title: Container(
                padding: EdgeInsets.only(right: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.columnChildren,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
 }