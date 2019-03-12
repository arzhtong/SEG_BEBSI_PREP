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
            //padding: EdgeInsets.only(top: 10.0),
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
      print(document.documentID);

      if (document['type'] == "categoryList") {
        lists.add(CategoryCard(document['contents'],
            document['title'],
            document['type'],
            widget._testID,
            widget._appointmentID));
      } else if (document['type'] == "informations") {
        informations.add(CategoryCard(document['contents'],
            document['title'],
            document['type'],
            widget._testID,
            widget._appointmentID));
      } else if (document['type'] == "faqs") {
        faqs.add(CategoryCard(document['contents'],
            document['title'],
            document['type'],
            widget._testID,
            widget._appointmentID));
      } else {
        recipes.add(CategoryCard(document['contents'],
            document['title'],
            document['type'],
            widget._testID,
            widget._appointmentID));
      }
    });

    return Column(
      children: <Widget>[
        ExpansionTile(
          initiallyExpanded: true,
          title: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.info,
                color: Colors.white,
              ),
            ),
            title: Text("Information"),
          ),
          children: informations,
        ),
        ExpansionTile(
          initiallyExpanded: true,
          title: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.list,
                color: Colors.white,
              ),
            ),
            title: Text("Lists"),
          ),
          children: lists,
        ),
        ExpansionTile(
          initiallyExpanded: true,
          title: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(
                Icons.fastfood,
                color: Colors.white,
              ),
            ),
            title: Text("Repiceps"),
          ),
          children: recipes,
        ),
        ExpansionTile(
          initiallyExpanded: true,
          title: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.question_answer,
                color: Colors.white,
              ),
            ),
            title: Text("FAQs"),
          ),
          children: faqs,
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String contents;
  final String title;
  final String type;
  final String _testID;
  final String _appointmentID;

  CategoryCard(this.contents, this.title, this.type, this._testID, this._appointmentID);

  Widget _getCategoryIcon(String type) {
    switch (type) {
      case "informations":
        return CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(
            Icons.info,
            color: Colors.white,
          ),
        );
      case "categoryList":
        return CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(
            Icons.list,
            color: Colors.white,
          ),
        );
      case "recipeView":
        return CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(
            Icons.fastfood,
            color: Colors.white,
          ),
        );
      default:
        return CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(
            Icons.question_answer,
            color: Colors.white,
          ),
        );
    }
  }

  Future _navigate(dynamic context) {
    //TODO: add links to the relevant pages

    switch (type) {
      case "informations":
        return Navigator.push(context, MaterialPageRoute(builder: (context) => InformationParser(_testID, contents)));
      case "categoryList":
        return null;
      case "recipieView":
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
          elevation: 3.0,
          child: InkWell(
              onTap: () {
                _navigate(context);
              },
              child: ListTile(
                //leading: _getCategoryIcon(type),
                title: Text(title),
              )
          ),
        )
    );
  }
}