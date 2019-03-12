import 'package:flutter/material.dart';

import 'package:prep/widgets/recipe/recipe_note.dart';
import 'package:prep/widgets/recipe/recipe_ingredient_list_item.dart';
import 'package:prep/widgets/recipe/recipe_instruction.dart';

class RecipeCardContent extends StatelessWidget {
  final List<String> ingredients;
  final List<String> method;
  final String note;

  RecipeCardContent({this.ingredients, this.method, this.note});

  static const String _ingredientListHeadline = "Show ingredients";
  static const String _preparationsHeadline = "Preparations";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        <Widget>[
          _buildShowIngredientExpansionTile(ingredients, context),
          SizedBox(
            height: 16.0,
          ),
        ],
        _buildPreparations(method, context),
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

  Widget _buildShowIngredientExpansionTile(
      List<String> ingredients, BuildContext context) {
    List<Widget> _ingredientListItems = [];

    for (String ingredient in ingredients) {
      _ingredientListItems.add(
        RecipeIngredientListItem(ingredient),
      );
    }

    return ExpansionTile(
      title: Text(
        _ingredientListHeadline,
        style: Theme.of(context).textTheme.button,
      ),
      children: _ingredientListItems,
      backgroundColor: Colors.black12,
      initiallyExpanded: false,
    );
  }

  List<Widget> _buildPreparations(List<String> method, BuildContext context) {
    List<Widget> retVal = [
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0, 16.0),
        child: Text(
          _preparationsHeadline,
          style: Theme.of(context).textTheme.headline.copyWith(fontSize: 18.0),
        ),
      ),
    ];

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
