import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    mappedData.values.forEach((value) {
      Map<dynamic, dynamic> myMap = value;
      List<dynamic> list = myMap.values.elementAt(2);
      String name = myMap.values.elementAt(0);
      String description = myMap.values.elementAt(1);

      listOfDropDowns.add(DescriptiveExpansionTile(name, description,list.toString()));
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

  DescriptiveExpansionTile(String category, String description,String items){
    this.category = category;
    this.description =description;
    columnChildren=new List();
        if (description.isNotEmpty){
      columnChildren.add(
        Text(
          description,
          style: TextStyle(
            color: Colors.grey[600],
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

  // Widget makeDatas(BuildContext context,DocumentSnapshot document,int i,){
  //   for (int j=0;j<=document['name'].length;j++){
  //   return Card(child: new Column(
  //     mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //       ExpansionTile(title: new Text(document[0]['testfield'].toString()),
  //         children: <Widget>[
  //           new ListTile(title: new Text(formatItemList(document['fatsAndOils']['list'].toString())),)
  //         ],
  //       )
  //     ]
  //   ,)
  // ,);


  //   }

  //     }
  // }
  //  _buildExpandableContent(Vehicle vehicle) {
  //   List<Widget> columnContent = [];

  //   for (String content in vehicle.contents)
  //     columnContent.add(
  //       new ExpansionTile(
  //         title: new Text(content, style: new TextStyle(fontSize: 18.0),),
  //         leading: new Icon(vehicle.icon),
  //       ),
  //     );

  //   return columnContent;
  // }

  String formatItemList(String rawItems){
    String formattedList = "";
    List<String> rawItemsList = rawItems.split(",");
    String remainderstring= rawItemsList.elementAt(rawItemsList.length-1);
    for (var i  = 0; i < rawItemsList.length - 1; i++){
      formattedList = formattedList + rawItemsList.elementAt(i) + " • ";
    }
    for (var j=0;j<=formattedList.length-1;j++){
      if (formattedList.substring(j,j+1)=='[' || formattedList.substring(j,j+1)==']'){
       formattedList= formattedList.replaceRange(j, j+1, ' ');
      }
      for (var k=0;k<=remainderstring.length-1;k++){
        if (remainderstring.substring(k,k+1)==']'){
         remainderstring=remainderstring.replaceRange(k, k+1, '');
        }
      }
    return formattedList + remainderstring;
  }
    return formattedList + remainderstring;
  }