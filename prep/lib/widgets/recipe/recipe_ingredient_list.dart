import 'package:flutter/material.dart';

import 'package:prep/utils/misc_functions.dart'
    show convertDynamicListToStringList;

import 'package:prep/widgets/recipe/recipe_ingredient_list_item.dart';

class RecipeIngredientList extends StatelessWidget {
  static const String _ingredientListHeadline = "Show ingredients";

  final dynamic dynamicIngredientList;

  RecipeIngredientList(this.dynamicIngredientList);

  @override
  Widget build(BuildContext context) {
    List<Widget> _ingredientListItems = [];

    for (String ingredient
        in convertDynamicListToStringList(dynamicIngredientList)) {
      _ingredientListItems.add(
        RecipeIngredientListItem(ingredient),
      );
    }

    return ExpansionTile(
      key: Key('ingredientList'),
      title: Text(
        _ingredientListHeadline,
        style: Theme.of(context).textTheme.button,
      ),
      children: _ingredientListItems,
      backgroundColor: Colors.black12,
      initiallyExpanded: false,
    );
  }
}
