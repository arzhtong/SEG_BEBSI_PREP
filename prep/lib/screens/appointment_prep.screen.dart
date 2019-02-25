import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import './allowed_foods.dart';
class AppointmentPrep extends StatefulWidget{
  @override
  _AppointmentPrepState createState() => new _AppointmentPrepState();
  }

class _AppointmentPrepState extends State<AppointmentPrep> {
  final List<String>listof=["Allowed Foods","Not Allowed Foods","FAQ Contents","Information Contents","Recipe List"];
  // List<DocumentSnapshot> categories;
  // List<DocumentSnapshot> id;
  _AppointmentPrepState(){
    // categories=new List();
    // id = new List();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new ListView.builder(
          itemBuilder: (_,int index)=>CategoryCard(this.listof[index]),
          itemCount: this.listof.length,

        //     CategoryCard("Allowed foods", 139, Colors.green[200], Colors.yellow[200],'assets/vegpacket.png'),
        //     CategoryCard("Not allowed foods", 50, Colors.red[200], Colors.orange[200],'assets/images/friedchicken.jpeg'),
        //     CategoryCard("Extra information", 63, Colors.orange[100], Colors.pink[100],'assets/images/friedchicken.jpeg'),
        //     CategoryCard("Other category", 73, Colors.blue[200], Colors.green[200],'assets/images/friedchicken.jpeg'),
        // ]
      ),
    ),
    );
    
      //padding: const EdgeInsets.all(40.0),
   
     
}
}
//   void getData() async{
//     Firestore.instance.collection('tests').getDocuments().then((query){
//       query.documents.forEach((document){
//       id.add(document);
//       id(0).  
//       })
//     }
//       })
//     }
//   }
// }

class CategoryCard extends StatelessWidget {
  
  String itemname;
  
  CategoryCard(this.itemname){
    
  }

  @override
  Widget build(BuildContext context) { 
    // var assetimage=AssetImage(location);
    // var image=new Image(image: assetimage,height: 24.0, width: 24.0, fit: BoxFit.fitWidth);
    return new Card(
      elevation: 5.0, 
      child: InkWell(
        onTap: () {
          Navigator.push( 
              context,
              MaterialPageRoute(builder: (context) => AllowedFoods())
          );
        }, 
        child: new Container(
          margin:EdgeInsets.all(10.0),
          padding:EdgeInsets.all(10.0), 
        child: new Row(
          children: <Widget>[
        new CircleAvatar(
          child: new Text(itemname[0])
        ),
        new Padding(padding:EdgeInsets.all(10.0)),
        new Text(itemname,style: TextStyle(fontSize: 20.0),)
             ],
          ),
        ),
      ),
    );
  }
}



// @override
// class IconImage extends StatelessWidget{
//   @override
//   String locations;
//   IconImage(String locations){
//     this.locations=locations;
//   }
//   Widget build (BuildContext context){
//     return new ImageIcon(new AssetImage(locations),
//       );
//   }
// }