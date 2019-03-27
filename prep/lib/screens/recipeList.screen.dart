import 'package:flutter/material.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/widgets/recipe/recipe_card.dart';

class RecipeListScreen extends StatelessWidget {
  static const String _appBarTitle = "Suggested Recipes";
  static const Widget _loadingWidget = Center(
    child: Text("Loading recipes..."),
  );
  static String _errorMessagePrefix = 'Error while loading recipes:';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: StreamBuilder(
        stream: BackendProvider.of(context).backend.recipeSnapshots,
        builder: (context, collectionSnapshot) {
          if (!collectionSnapshot.hasData) {
            return _loadingWidget;
          } else if (collectionSnapshot.hasError) {
            return Center(
              child: Text(_errorMessagePrefix + collectionSnapshot.error),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (_, index) => RecipeCard(
                  data: collectionSnapshot.data.documents[index].data,
                ),
            itemCount: collectionSnapshot.data.documents.length,
          );
        },
      ),
    );
  }
}
