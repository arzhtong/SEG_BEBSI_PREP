import 'package:flutter/material.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/widgets/recipe/recipe_ingredient_list.dart';
import 'package:prep/widgets/recipe/recipe_method_list.dart';
import 'package:prep/widgets/recipe/recipe_note.dart';
import 'package:prep/widgets/recipe/external_recipe_link.dart';

class RecipeCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> content = [];
    //get data
    final documentData = DocumentDataProvider.of(context).documentData;

    final dynamic dynamicIngredientListData = documentData['ingredients'];

    final dynamic dynamicMethodListData = documentData['method'];
    final dynamic dynamicExternalUrlData =
        documentData['externalURL']?.toString();
    final dynamic dynamicNoteData = documentData['note']?.toString();

    //check data

    //internal recipe must either exist fully or doesn't at all
    bool hasInternalRecipe =
        (dynamicIngredientListData != null) && (dynamicMethodListData != null);
    /* assert(hasInternalRecipe ||
        ((dynamicMethodListData == null) &&
            (dynamicIngredientListData == null))); */

    //at least one form of recipe must be present
    //assert(hasInternalRecipe || dynamicExternalUrlData != null);

    //generate widgets from data
    if (hasInternalRecipe) {
      _addToContentWithSpacer(
          RecipeIngredientList(dynamicIngredientListData), content);
      _addToContentWithSpacer(RecipeMethodList(dynamicMethodListData), content);
    }

    if (dynamicExternalUrlData != null &&
        isURL(
          dynamicExternalUrlData,
          allowUnderscore: true,
          requireTld: false,
        )) {
      assert(dynamicExternalUrlData.runtimeType == String);
      _addToContentWithSpacer(
          ExternalRecipeLink(dynamicExternalUrlData), content);
    }

    if (dynamicNoteData != null) {
      assert(dynamicNoteData.runtimeType == String);
      content.add(RecipeNote(dynamicNoteData));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content,
    );
  }

  void _addToContentWithSpacer(Widget toAdd, List<Widget> addTo) => addTo
    ..add(toAdd)
    ..add(
      SizedBox(
        height: 16.0,
      ),
    );
}
