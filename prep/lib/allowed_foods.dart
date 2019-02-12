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
          ExpansionTile(
            leading: Icon(Icons.local_florist),
            title: Text("Condiments & seasonings"),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
                title: Text("Salt - "
                  "Pepper - "
                  "Any natural herbs or spices - "
                  "Full-fat or home-made mayonnaise",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.restore_from_trash),
            title: Text("Drinks"),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
                title: Text("Mineral water - "
                    "Sparkling water - "
                    "Coffee - "
                    "Tea without milk or sugar",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.child_friendly),
            title: Text("Dairy and alternatives"),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
                title: Text("Creme fraiche - "
                    "Double cream - "
                    "Sour cream - "
                    "Butter eggs - "
                    "Any non-processed cheese e.g. cheddar",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.fastfood),
            title: Text("Fats & oils"),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
                title: Text("Butter - "
                    "All vegetable oils (e.g. olive, peanut, sunflower, rapeseed and palm oil) - "
                    "The fat on meat",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.watch),
            title: Text("Fish & shelfish"),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
                title: Text("All non-processed fish/shellfish are allowed - "
                    "Fresh salmon - "
                    "Tuna - "
                    "Tilapia - "
                    "All fresh white fish such as cod",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.airport_shuttle),
            title: Text("Meat"),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
                title: Text("All non-processed meats are allowed - "
                    "Beef - "
                    "Goat - "
                    "Lamb - "
                    "Pork - "
                    "Veal",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.directions_run),
            title: Text("Poultry"),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
                title: Text("All non-processed poultry along with their eggs are allowed - "
                    "chicken - "
                    "turkey - "
                    "duck",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.accessible_forward),
            title: Text("Vegetarian Foods"),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
                title: Text("Eggs - "
                    "cheddar and other non-processed cheeses - "
                    "nuts (except chestnuts) - "
                    "Quorn pieces and Quorn meat free fillets (all other Quorn products are not permitted)",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.ac_unit),
            title: Text("Vegetable"),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(70.0, 0.0, 0.0, 0.0),
                title: Text("Fresh and frozen vegetables - "
                    "avocado - "
                    "asparagus - "
                    "artichokes - "
                    "aubergines - "
                    "broccoli - "
                    "bok choy - "
                    "brussel sprouts - "
                    "bean sprouts - "
                    "celery - "
                    "cucumber - "
                    "courgettes - "
                    "cauliflower - "
                    "fennel - "
                    "garlic - "
                    "lettuce - "
                    "leeks - "
                    "mushrooms - "
                    "okra - "
                    "peppers - "
                    "radishes - "
                    "squash - "
                    "spring onions - "
                    "shallots - "
                    "spinach - "
                    "tomatoes - "
                    "turnips - "
                    "fresh herbs",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}