import 'package:flutter/material.dart';

import 'package:prep/widgets/recipe/recipe_card_content.dart';

class RecipeCardBody extends StatelessWidget {
  final String title;
  final List<String> ingredients;
  final List<String> method;
  final String note;

  RecipeCardBody(
      {@required this.title,
      @required this.ingredients,
      @required this.method,
      @required this.note});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          this.title,
          maxLines: 2,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      children: <Widget>[
        RecipeCardContent(
          ingredients: this.ingredients,
          method: this.method,
          note: this.note,
        ),
      ],
    );
  }
}
