import 'package:flutter/material.dart';

import 'package:prep/utils/query.dart';
import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/widgets/recipe/recipe_note.dart';
import 'package:prep/widgets/recipe/recipe_ingredient_list_item.dart';
import 'package:prep/widgets/recipe/recipe_instruction.dart';

class RecipeCardContent extends StatelessWidget {
  static const String _ingredientListHeadline = "Show ingredients";
  static const String _preparationsHeadline = "Preparations";

  @override
  Widget build(BuildContext context) {
    var note = FirestoreDocumentDataProvider.of(context).documentData['note'];
    assert(note.runtimeType == String);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        <Widget>[
          _buildShowIngredientExpansionTile(context),
          SizedBox(
            height: 16.0,
          ),
        ],
        _buildPreparationsList(context),
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

  Widget _buildShowIngredientExpansionTile(BuildContext context) {
    var dynamicIngredients =
        FirestoreDocumentDataProvider.of(context).documentData['ingredients'];

    List<Widget> _ingredientListItems = [];

    for (String ingredient
        in convertDynamicListToStringList(dynamicIngredients)) {
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

  List<Widget> _buildPreparationsList(BuildContext context) {
    var dynamicMethodInstructions =
        FirestoreDocumentDataProvider.of(context).documentData['method'];

    List<String> methodInstructions =
        convertDynamicListToStringList(dynamicMethodInstructions);

    List<Widget> retVal = [
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0, 16.0),
        child: Text(
          _preparationsHeadline,
          style: Theme.of(context).textTheme.headline.copyWith(fontSize: 18.0),
        ),
      ),
    ];

    for (int i = 0; i < methodInstructions.length; i++) {
      retVal.add(
        RecipeInstruction(
          ordering: i + 1,
          instruction: methodInstructions[i],
        ),
      );

      //add dividers and ending padding
      if (i != methodInstructions.length - 1) {
        retVal.add(
          Divider(),
        );
      }
    }

    return retVal;
  }
}
