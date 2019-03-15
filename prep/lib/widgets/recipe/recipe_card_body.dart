import 'package:flutter/material.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/widgets/recipe/recipe_card_content.dart';

class RecipeCardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = FirestoreDocumentDataProvider.of(context).documentData['title'];
    var subtitle =
        FirestoreDocumentDataProvider.of(context).documentData['subtitle'];
    assert(title != null);
    assert(title is String);
    if (subtitle != null) {
      assert(subtitle is String);
    }

    var recipeName = title;
    if (subtitle != null) {
      recipeName += "\n" + subtitle;
    }

    return ExpansionTile(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          recipeName,
          maxLines: 2,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      children: <Widget>[
        RecipeCardContent(),
      ],
    );
  }
}
