import 'package:flutter/material.dart';

class AllowedFoods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Allowed foods'),
      ),
      body: ListView(
        children: <Widget>[
          DescriptiveExpansionTile("Condiments & seasoning", "", "salt%pepper%any natural herb or spices%full-fat or home-made mayonnaise", Icons.local_florist),
          DescriptiveExpansionTile("Drinks", "An example of a very long description for a food category", "mineral water%sparkling water%coffee%tea without milk or sugar", Icons.restore_from_trash),
          DescriptiveExpansionTile("Dairy and alternatives", "", "creme fraiche%double cream%sour cream%butter%eggs%any non-processed cheese e.g. cheddar", Icons.child_friendly),
          DescriptiveExpansionTile("Fats & oils", "", "butter%all vegetable oils (e.g. olive, peanut, sunflower, rapeseed and palm oild)%the fat on meat", Icons.fastfood),
          DescriptiveExpansionTile("Fish & shelfish", "All non-processed fish/shellfish are allowed", "fresh salmon%tuna%tilapia%all fresh white fish such as cod", Icons.watch),
          DescriptiveExpansionTile("Meats", "All non-processed meats are allowed", "beef%goat%lamb%pork%veal", Icons.ac_unit),
          DescriptiveExpansionTile("Poultry", "All non-processed pultry along with their eggs are allowed", "chicken%turkey%duck", Icons.alarm),
          DescriptiveExpansionTile("Vegetarian foods", "", "eggs%cheddar and other non-processed cheeses%nuts (except chestnuts)%Quorn pieces and Quorn meat free fillets (all other Quorn products are not permitted)", Icons.airport_shuttle),
          DescriptiveExpansionTile("Vegetables", "Fresh and frozen vegetables", "avocado%asparagus%artichokes%aubergines%broccoli%bok choy%brussel sprouts%bean sprouts%celery%cucumber%courgetters%cauliflower%fennel%garlic%lettuce%leeks"
              "%mushroom%okra%peppers%radishes%squash%spring onions%shallots%spinach%tomatoes%turnips%fresh herbs", Icons.assignment_ind),
        ],
      ),
    );
  }
}

class DescriptiveExpansionTile extends StatelessWidget {
  String category;
  String description;
  String items;
  IconData icon;
  List<Widget> columnChildren;

  DescriptiveExpansionTile(String category, String description, String items, IconData icon) {
    this.category = category;
    this.description = description;
    this.items = items;
    this.icon = icon;
    columnChildren = new List();

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
      leading: Icon(icon),
      title: Text(category),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
          title: Container(
            padding: EdgeInsets.only(right: 50.0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren,
            ),
          ),
        ),
      ],
    );
  }

  String formatItemList(String rawItems){
    String formattedList = "";
    List<String> rawItemsList = rawItems.split("%");

    for (var i  = 0; i < rawItemsList.length - 1; i++){
      formattedList = formattedList + rawItemsList.elementAt(i) + " • ";
    }

    return formattedList + rawItemsList.elementAt(rawItemsList.length - 1);
  }
}