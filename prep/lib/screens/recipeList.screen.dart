import 'package:flutter/material.dart';
import 'package:prep/utils/query.dart';

import 'package:prep/widgets/recipe/recipe_card.dart';
import 'package:prep/utils/prep_custom_icons.dart';

import 'package:prep/mockData/mock_recipe_data.dart';

const String testID = "VyyiBYwp0xX4nJyvX9oN";

class RecipeListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecipeListScreenState();
}

//TODO: Add filter by favorite functionality
class _RecipeListScreenState extends State<RecipeListScreen> {
  bool isFilterEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suggested Recipes"),
        actions: <Widget>[
          //TODO: Implement recipe search!
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              PrepCustomIcons.favorite_half,
              //TODO: Use theme colors.
              color: (isFilterEnabled)
                  ? Colors.white
                  : Theme.of(context).disabledColor,
            ),
            onPressed: () {
              setState(
                () {
                  isFilterEnabled = !isFilterEnabled;
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Queries.recipeSnapshots,
        builder: (context, collectionSnapshot) {
          if (!collectionSnapshot.hasData) {
            return Text("Loading recipes...");
          }
          return ListView.builder(
            itemBuilder: (_, index) {
              //RecipeMockUp recipe = mockRecipeList[index];

              return RecipeCard(
                snapshot: collectionSnapshot.data.documents[index],
              );
            },
            itemCount: collectionSnapshot.data.documents.length,
          );
        },
      ),

      /* ListView.builder(
        itemBuilder: (_, index) {
          RecipeMockUp recipe = mockRecipeList[index];

          return RecipeCard(
            title: recipe.title,
            backgroundImage: recipe.backgroundImage,
            ingredients: recipe.ingredients,
            method: recipe.method,
            note: recipe.note,
          );
        },
        itemCount: mockRecipeList.length,
      ), */
    );
  }
}
