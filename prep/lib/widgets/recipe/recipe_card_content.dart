import 'package:flutter/material.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/widgets/recipe/recipe_ingredient_list.dart';
import 'package:prep/widgets/recipe/recipe_method_list.dart';
import 'package:prep/widgets/recipe/recipe_note.dart';
import 'package:prep/widgets/recipe/external_recipe_link.dart';

class RecipeCardContent extends StatelessWidget {
  final List<Widget> content = [];
  @override
  Widget build(BuildContext context) {
    //FIXME: Remove code duplication!!

    //get data
    final dynamic dynamicIngredientListData =
        FirestoreDocumentDataProvider.of(context).documentData['ingredients'];
    final dynamic dynamicMethodListData =
        FirestoreDocumentDataProvider.of(context).documentData['method'];
    final dynamic dynamicExternalUrlData =
        FirestoreDocumentDataProvider.of(context).documentData['externalURL'];

    //check data

    //internal recipe must either exist fully or doesn't at all
    bool hasInternalRecipe =
        (dynamicIngredientListData != null) && (dynamicMethodListData != null);
    assert(hasInternalRecipe |
        ((dynamicMethodListData == null) &&
            (dynamicIngredientListData == null)));

    //at least one form of recipe must be present
    assert(hasInternalRecipe || dynamicExternalUrlData != null);

    //generate widgets from data
    if (hasInternalRecipe) {
      content.add(RecipeIngredientList(dynamicIngredientListData));
      _addSpacer();
      content.add(RecipeMethodList(dynamicMethodListData));
      _addSpacer();
    }

    if (dynamicExternalUrlData != null) {
      assert(dynamicExternalUrlData.runtimeType == String);
      content.add(ExternalRecipeLink(dynamicExternalUrlData));
      _addSpacer();
    }

    final dynamic dynamicNoteData =
        FirestoreDocumentDataProvider.of(context).documentData['note'];
    if (dynamicNoteData != null) {
      assert(dynamicNoteData.runtimeType == String);
      content.add(RecipeNote(dynamicNoteData));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content,
    );
  }

  void _addSpacer() => content.add(
        SizedBox(
          height: 16.0,
        ),
      );
}
