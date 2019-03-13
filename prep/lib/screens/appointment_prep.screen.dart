import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'information_parser.screen.dart';
import 'faq_parser.screen.dart';
import 'package:prep/screens/category.screen.dart';
import 'package:prep/utils/query.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AppointmentPrep extends StatefulWidget {
  final DateTime _appointmentDatetime;

  AppointmentPrep(this._appointmentDatetime);

  @override
  _AppointmentPrepState createState() => _AppointmentPrepState();
}

class _AppointmentPrepState extends State<AppointmentPrep> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Queries.prepCardsSnapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(),);
          return StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(10.0),
            crossAxisCount: 4,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>_buildGrid(context,snapshot.data.documents[index]),
            staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
          );
        }
    );
  }

  Widget _buildGrid(BuildContext context, DocumentSnapshot document) {
    return CategoryCard(document['contents'],
      document['title'],
      document['type'],
      Colors.white,
      widget._appointmentDatetime
    );
  }
}

//class CategoryExpansionTile extends StatelessWidget {
//  final String name;
//  final List<Widget> contents;
//  final Color color;
//  final IconData icon;
//
//  CategoryExpansionTile(this.name, this.contents, this.color, this.icon);
//
//  @override
//  Widget build(BuildContext context) {
//    return ExpansionTile(
//      initiallyExpanded: true,
//      title: ListTile(
//        contentPadding: EdgeInsets.only(left: 0.0),
//        leading: CircleAvatar(
//          backgroundColor: color,
//          child: Icon(
//            icon,
//            color: Colors.white,
//          ),
//        ),
//        title: Text(name),
//      ),
//      children: contents
//    );
//  }
//}

class CategoryCard extends StatelessWidget {
  final String contents;
  final String title;
  final String type;
  final Color color;
  final DateTime _appointmentDateTime;

  CategoryCard(this.contents, this.title, this.type, this.color, this._appointmentDateTime);

  Future _navigate(dynamic context) {
    //TODO: add links to the relevant pages

    switch (type) {
      case "informations":
        return Navigator.push(context, MaterialPageRoute(builder: (context) => InformationParser(contents)));
      case "categoryList":
        return null;
      case "recipeView":
        return null;
      default:
        return Navigator.push(context, MaterialPageRoute(builder: (context) => FaqParser(_appointmentDateTime)));
    }
  }

  CircleAvatar _getIcon(){
    if (type == "categoryList") {
        return CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.list,
            color: Colors.white,
          ),
        );
    } else if (type == "informations") {
      return CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.info,
          color: Colors.white,
        ),
      );
    } else if (type == "faqs") {
      return CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(
          Icons.question_answer,
          color: Colors.white,
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(
          Icons.fastfood,
          color: Colors.white,
        ),
      );
    }
  }

  String _getCategory(){
    switch (type) {
      case "informations":
        return "Information";
      case "categoryList":
        return "List";
      case "recipeView":
        return "Recipe";
      default:
        return "FAQ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 3.0,
      child: InkWell(
        onTap: () {
          _navigate(context);
        },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: Text(
                  _getCategory(),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic
                  ),
                ),
                leading: _getIcon(),
              ),
              ListTile(
                title: Text(
                  title,
                  //maxLines: 3,
                ),
              ),
            ],
          )
      ),
    );
  }
}