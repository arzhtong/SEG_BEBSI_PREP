import 'package:flutter/material.dart';

import './allowed_foods.dart';

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
            CategoryCard("Allowed foods", 139, Colors.green[200], Colors.yellow[200]),
            CategoryCard("Not allowed foods", 50, Colors.red[200], Colors.orange[200]),
            CategoryCard("Extra information", 63, Colors.orange[100], Colors.pink[100]),
            CategoryCard("Other category", 73, Colors.blue[200], Colors.green[200]),
          ],
        ),

        CategoryCard("Sample Menu", 30, Colors.purple[200], Colors.blue[200]),
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
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllowedFoods())
          );
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