import 'package:flutter/material.dart';

import 'package:prep/screens/recipeList.screen.dart';
import 'package:prep/screens/information_parser.screen.dart';
import 'package:prep/screens/list_parser.screen.dart';
import 'package:prep/screens/faq_parser.screen.dart';

class CategoryCard extends StatelessWidget {
  final String documentID;
  final String title;
  final String type;

  CategoryCard(this.documentID, this.title, this.type);

  Future _navigate(dynamic context) {
    switch (type) {
      case "article":
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InformationParser(documentID, title)));
      case "categoryList":
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryListParser(documentID, title)));
      case "recipe":
        return Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeListScreen()));
      default:
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => FaqParser()));
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
    } else if (type == "article") {
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

  String _getCategory() {
    switch (type) {
      case "article":
        return "Article";
      case "categoryList":
        return "List";
      case "recipe":
        return "Recipe";
      default:
        return "FAQ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.5),
      child: Card(
        color: Colors.white,
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
                        color: Colors.grey[400], fontStyle: FontStyle.italic),
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
            )),
      ),
    );
  }
}
