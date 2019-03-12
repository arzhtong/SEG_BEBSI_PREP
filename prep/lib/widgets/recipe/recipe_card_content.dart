import 'package:flutter/material.dart';

import 'package:prep/widgets/recipe/recipe_note.dart';
import 'package:prep/widgets/recipe/recipe_ingredient_list_item.dart';
import 'package:prep/widgets/recipe/recipe_instruction.dart';

class RecipeCardContent extends StatelessWidget {
  final List<String> ingredients;
  final List<String> method;
  final String note;

  RecipeCardContent({this.ingredients, this.method, this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        <Widget>[
          _buildIngredientList(ingredients, context),
          SizedBox(
            height: 16.0,
          ),
        ],
        _buildMethodInstructions(method),
        <Widget>[
          SizedBox(
            height: 16.0,
          ),
          RecipeNote(
            note: note,
          ),
        ],
      ].expand((x) => x).toList(),
    );
  }

  Widget _buildIngredientList(List<String> ingredients, BuildContext context) {
    List<Widget> _ingredientListItems = [];

    for (String ingredient in ingredients) {
      _ingredientListItems.add(
        RecipeIngredientListItem(ingredient),
      );
    }

    return ExpansionTile(
      title: Text(
        "Show ingredients",
        style: Theme.of(context).textTheme.button,
      ),
      children: _ingredientListItems,
      backgroundColor: Colors.black12,
      initiallyExpanded: false,
    );
  }

  List<Widget> _buildMethodInstructions(List<String> method) {
    List<Widget> retVal = [];

    for (int i = 0; i < method.length; i++) {
      retVal.add(
        RecipeInstruction(
          ordering: i + 1,
          instruction: method[i],
        ),
      );

      //add dividers and ending padding
      if (i != method.length - 1) {
        retVal.add(
          Divider(),
        );
      }
    }

    return retVal;
  }
}
