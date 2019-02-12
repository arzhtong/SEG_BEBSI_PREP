import 'package:flutter/material.dart';

class AppointmentPrep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 1,

      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      children: <Widget>[
        GridView.count(
        crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            CategoryCard("Allowed foods", 139, Colors.green[400], Colors.yellow[400]),
            CategoryCard("Not allowed foods", 50, Colors.red[400], Colors.orange[400]),
            CategoryCard("Other category", 73, Colors.blue[400], Colors.green[400]),
            CategoryCard("Extra information", 63, Colors.cyan[200], Colors.teal[400]),
          ],
        ),

        CategoryCard("Sample Menu", 30, Colors.purple[400], Colors.blue[400]),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  String categoryName;
  int numberOfItems;
  Color left;
  Color right;

  CategoryCard(String catName, int itemsNo, Color leftCol, Color rightCol){
    this.categoryName = catName;
    this.numberOfItems = itemsNo;
    this.left = leftCol;
    this.right = rightCol;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: () {
//          Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => AppointmentInfo())
//          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.9],
                  colors: [
                    left,
                    right,
                  ],
                ),
              ),
              height: 90.0,
            ),
            ListTile(
              title: Text(categoryName),
              subtitle: Text(numberOfItems.toString() + " items"),
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
      child:  Container(
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
      ),
    );
  }
}