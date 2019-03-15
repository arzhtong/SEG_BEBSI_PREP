import 'package:flutter/material.dart';

import 'package:prep/utils/query.dart';
import 'package:prep/widgets/recipe/recipe_card.dart';

class RecipeListScreen extends StatelessWidget {
  static const String _appBarTitle = "Suggested Recipes";
  static const Widget _loadingWidget = Text("Loading recipes...");
  static String _errorMessagePrefix = 'Error while loading recipes:';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: StreamBuilder(
        stream: Queries.recipeSnapshots,
        builder: (context, collectionSnapshot) {
          if (!collectionSnapshot.hasData) {
            return _loadingWidget;
          } else if (collectionSnapshot.hasError) {
            return Text(_errorMessagePrefix + collectionSnapshot.error);
          }
          return ListView.builder(
            itemBuilder: (_, index) =>
                RecipeCard(
                  snapshot: collectionSnapshot.data.documents[index],
                ),
            itemCount: collectionSnapshot.data.documents.length,
          );
        },
      ),
    );
  }
}
