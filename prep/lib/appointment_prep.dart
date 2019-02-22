import 'package:flutter/material.dart';

import './allowed_foods.dart';

class AppointmentPrep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: <Widget>[
            CategoryCard("Allowed foods", 139, Colors.green[200], Colors.yellow[200],'assets/vegpacket.png'),
            CategoryCard("Not allowed foods", 50, Colors.red[200], Colors.orange[200],'assets/images/friedchicken.jpeg'),
            CategoryCard("Extra information", 63, Colors.orange[100], Colors.pink[100],'assets/images/friedchicken.jpeg'),
            CategoryCard("Other category", 73, Colors.blue[200], Colors.green[200],'assets/images/friedchicken.jpeg'),
        ]
      )
    );
    
      //padding: const EdgeInsets.all(40.0),
   
     
}
}

class CategoryCard extends StatelessWidget {
  String categoryName;
  int numberOfItems;
  Color left;
  Color right;
  String location;

  CategoryCard(String catName, int itemsNo, Color leftCol, Color rightCol, String location){
    this.categoryName = catName;
    this.numberOfItems = itemsNo;
    this.left = leftCol;
    this.right = rightCol;
    this.location=location;
  }

  @override
  Widget build(BuildContext context) { 
    var assetimage=AssetImage(location);
    var image=new Image(image: assetimage,height: 24.0, width: 24.0, fit: BoxFit.fitWidth);
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllowedFoods())
          );
        }, 
        child: new Row(
          children: <Widget>[
        new Expanded(
        child: new Column(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //  Container(
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
            //     gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomLeft,
            //       stops: [0.1, 0.9],
            //       colors: [
            //         left,
            //         right,
            //       ],
            //     ),
            //   ),
            //   height: 90.0,
            // ),
            ListTile(
              leading: new ImageIcon(new AssetImage('assets/images/vegpacket.png'), size: 80.0, color: Colors.blue),
              title: Text(categoryName),
              subtitle: Text(numberOfItems.toString() + " items"),
              
            ),
           
          ],
        ),
      ),
      
          ],
      ),
    ),
    );
  }
}


//custom made card
class CategoryBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: Text("Sample text"),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0
            )
          ]
        ),
        
      );
      
    
  }
}
@override
class IconImage extends StatelessWidget{
  @override
  String locations;
  IconImage(String locations){
    this.locations=locations;
  }
  Widget build (BuildContext context){
    return new ImageIcon(new AssetImage(locations),
      );
  }
}