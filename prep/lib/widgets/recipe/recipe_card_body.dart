import 'package:flutter/material.dart';
import 'package:prep/utils/constants.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/widgets/recipe/recipe_card_content.dart';

class RecipeCardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = DocumentDataProvider.of(context).documentData['title'];
    var subtitle = DocumentDataProvider.of(context).documentData['subtitle'];
    assert(title != null);
    assert(title is String);
    if (subtitle != null) {
      assert(subtitle is String);
    }

    var recipeName = [
      Text(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: Theme.of(context).textTheme.headline,
      ),
    ];
    if (subtitle != null) {
      recipeName.add(
        Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 18.0),
        ),
      );
    }

    return ExpansionTile(
      initiallyExpanded: Constants.kIsDebug,
      title: Column(
        verticalDirection: VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: recipeName,
      ),
      children: <Widget>[
        RecipeCardContent(),
      ],
    );
  }
}
