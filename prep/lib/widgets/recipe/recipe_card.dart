import 'package:flutter/material.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/widgets/recipe/recipe_card_body.dart';
import 'package:prep/widgets/recipe/recipe_card_header.dart';

//TODO: Add ancestor assertions in children
class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> data;

  RecipeCard({@required this.data});

  @override
  Widget build(BuildContext context) {
    return DocumentDataProvider(
      documentData: data,
      child: Container(
        padding: EdgeInsets.only(bottom: 5.0),
        width: MediaQuery.of(context).size.width,
        child: Material(
          child: Card(
            elevation: 3.0,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                RecipeCardHeader(),
                RecipeCardBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
