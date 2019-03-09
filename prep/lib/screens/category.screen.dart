import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';

class Category extends StatefulWidget{
  String _contents;
  Category(this._contents);

  @override
  State<StatefulWidget> createState() {
    return _CategoryState();
  }
}
class _CategoryState extends State<Category>{
  @override
  Widget build(BuildContext context) {
    print("Contents received in category state: X" + widget._contents + "X");
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Appointments'),
      ),
      body: StreamBuilder(
      stream: Firestore.instance.collection('tests').document('VyyiBYwp0xX4nJyvX9oN').collection('prepContents').document(widget._contents).get().asStream(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return const Text("Loading...");
        return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) => _buildDropDownList(context, snapshot.data),
        );
      }
    ),
    );
  }

  Widget _buildDropDownList(BuildContext context, DocumentSnapshot document){
    Map<String, dynamic> mappedData = document.data;
    List<Widget> listOfDropDowns = new List();

    SplayTreeMap sortedCategories = new SplayTreeMap.from(mappedData, (dynamic me, dynamic other){
      return me.toString().compareTo(other.toString());
    });

    sortedCategories.values.forEach((value) {
      Map<dynamic, dynamic> itemList = value;

      SplayTreeMap sortedMapKeys = new SplayTreeMap.from(itemList, (dynamic me, dynamic other){
        return me.toString().compareTo(other.toString());
      });

      List<dynamic> list = sortedMapKeys.values.elementAt(1);
      String name = sortedMapKeys.values.elementAt(2);
      String description = sortedMapKeys.values.elementAt(0);

      listOfDropDowns.add(DescriptiveExpansionTile(name, description,list)
      );
    });

    return Column(
      children: listOfDropDowns,
    );
  }
}

class DescriptiveExpansionTile extends StatelessWidget {
  String category;
  String description;
  List<Widget> columnChildren;

  DescriptiveExpansionTile(String category, String description,List<dynamic> items){
    this.category = category;
    this.description =description;
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
  
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.free_breakfast),
      title: Text(category),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
          title: Container(
            padding: EdgeInsets.only(right: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren,
               
              
            ),
          ),
        )
      ],
    );
    
  }
}
     
    // print(mappedData);

    // print("Keys--------------");
    // mappedData.keys.forEach((value) {
    //   print(value);
    // });

    // print("Values-----------");
    // mappedData.values.forEach((value) {
    //   print(value);
    // });

    // print("Sub values----------");
    // mappedData.values.forEach((value) {
    //   Map<dynamic, dynamic> myMap = value;
    //   print(myMap.values);
    // });

    // print("Sub Listsss----------");
    // mappedData.values.forEach((value) {
    //   Map<dynamic, dynamic> myMap = value;
    //   print(myMap.values.elementAt(2));
    // });




  String formatItemList(List<dynamic> elementlist){
   String rawItems="";

   elementlist.forEach((value){
     rawItems+=value + " " "•" + " ";
   }
   
   );
   rawItems=rawItems.replaceRange(rawItems.length-2,rawItems.length-1,' ');
    return rawItems;
  }