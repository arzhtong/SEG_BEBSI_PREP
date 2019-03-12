import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'information_parser.screen.dart';
import 'faq_parser.screen.dart';
import './category.screen.dart';

class AppointmentPrep extends StatefulWidget {
  final String _testID;
  final String _appointmentID;

  AppointmentPrep(this._testID, this._appointmentID);

  @override
  _AppointmentPrepState createState() => _AppointmentPrepState();
}

class _AppointmentPrepState extends State<AppointmentPrep> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('tests')
          .document(widget._testID).collection('prepCards').getDocuments().asStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) =>_buildWidget(context,snapshot.data)
          );
        }
    );
  }

  Widget _buildWidget(BuildContext context, QuerySnapshot snapshot) {
    List<Widget> lists = new List();
    List<Widget> informations = new List();
    List<Widget> recipes = new List();
    List<Widget> faqs = new List();

    snapshot.documents.forEach((document){
      //print(document.documentID);

      if (document['type'] == "categoryList") {
        lists.add(CategoryCard(document['contents'],
            document['title'],
            document['type'],
            widget._testID,
            widget._appointmentID,
            Colors.blue[50]));
      } else if (document['type'] == "informations") {
        informations.add(CategoryCard(document['contents'],
            document['title'],
            document['type'],
            widget._testID,
            widget._appointmentID,
            Colors.purple[50]));
      } else if (document['type'] == "faqs") {
        faqs.add(CategoryCard(document['contents'],
            document['title'],
            document['type'],
            widget._testID,
            widget._appointmentID,
            Colors.green[50]));
      } else {
        recipes.add(CategoryCard(document['contents'],
            document['title'],
            document['type'],
            widget._testID,
            widget._appointmentID,
            Colors.red[50]));
      }
    });

    return Column(
      children: <Widget>[
        CategoryExpansionTile("Information", informations, Colors.deepPurple, Icons.info),
        CategoryExpansionTile("FAQs", faqs, Colors.green, Icons.question_answer),
        CategoryExpansionTile("Lists", lists, Colors.blue, Icons.list),
        CategoryExpansionTile("Recipes", recipes, Colors.red, Icons.fastfood),
      ],
    );
  }
}

class CategoryExpansionTile extends StatelessWidget {
  final String name;
  final List<Widget> contents;
  final Color color;
  final IconData icon;

  CategoryExpansionTile(this.name, this.contents, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: ListTile(
        contentPadding: EdgeInsets.only(left: 0.0),
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(name),
      ),
      children: contents
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String contents;
  final String title;
  final String type;
  final String _testID;
  final String _appointmentID;
  final Color color;

  CategoryCard(this.contents, this.title, this.type, this._testID, this._appointmentID, this.color);

  Future _navigate(dynamic context) {
    //TODO: add links to the relevant pages

    switch (type) {
      case "informations":
        return Navigator.push(context, MaterialPageRoute(builder: (context) => InformationParser(_testID, contents)));
      case "categoryList":
        return null;
      case "recipeView":
        return null;
      default:
        return Navigator.push(context, MaterialPageRoute(builder: (context) => FaqParser(_testID, _appointmentID)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0, bottom: 5.0),
        child: Card(
          color: color,
          elevation: 3.0,
          child: InkWell(
              onTap: () {
                _navigate(context);
              },
              child: ListTile(
                title: Text(title),
              )
          ),
        )
    );
  }
}