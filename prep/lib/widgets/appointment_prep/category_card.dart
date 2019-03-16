import 'package:flutter/material.dart';

import 'package:prep/screens/recipeList.screen.dart';
import 'package:prep/screens/information_parser.screen.dart';
import 'package:prep/screens/list_parser.screen.dart';
import 'package:prep/screens/faq_parser.screen.dart';

class CategoryCard extends StatelessWidget {
  final String contents;
  final String title;
  final String type;
  final Color color;
  final DateTime _appointmentDateTime;

  CategoryCard(this.contents,
      this.title,
      this.type,
      this.color,
      this._appointmentDateTime);

  Future _navigate(dynamic context) {
    switch (type) {
      case "informations":
        return Navigator.push(context, MaterialPageRoute(builder:
            (context) => InformationParser(contents, title)));
      case "categoryList":
        return Navigator.push(context, MaterialPageRoute(builder:
            (context) => CategoryListParser(contents, title)));
      case "recipeView":
        return Navigator.push(context,
            MaterialPageRoute(builder: (context) => RecipeListScreen()));
      default:
        return Navigator.push(context, MaterialPageRoute(builder:
            (context) => FaqParser(_appointmentDateTime)));
    }
  }

  CircleAvatar _getIcon() {
    if (type == "categoryList") {
      return CircleAvatar(
        backgroundColor: Colors.blue[400],
        child: Icon(
          Icons.list,
          color: Colors.white,
        ),
      );
    } else if (type == "informations") {
      return CircleAvatar(
        backgroundColor: Colors.deepPurple[400],
        child: Icon(
          Icons.info,
          color: Colors.white,
        ),
      );
    } else if (type == "faqs") {
      return CircleAvatar(
        backgroundColor: Colors.green[400],
        child: Icon(
          Icons.live_help,
          color: Colors.white,
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.red[400],
        child: Icon(
          Icons.local_dining,
          color: Colors.white,
        ),
      );
    }
  }

  String _getCategory(){
    switch (type) {
      case "informations":
        return "Info";
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