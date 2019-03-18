import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/utils/query.dart';

class RecipeCardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184.0,
      child: Stack(
        children: <Widget>[
          //The background image
          Positioned.fill(
            child: _loadRecipeImageOrDefault(context),
          ),
          //Recipe chips
          Positioned(
            bottom: 0.0,
            right: 6.0,
            child: SizedBox(
              width: (MediaQuery.of(context).size.width * 2.5 / 3.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                verticalDirection: VerticalDirection.up,
                direction: Axis.horizontal,
                spacing: 4.0,
                alignment: WrapAlignment.end,
                children: _buildRecipeLabels(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRecipeLabels(BuildContext context) {
    var dynamicLabels =
        FirestoreDocumentDataProvider.of(context).documentData['labels'];

    if (dynamicLabels == null) return [];

    List<Chip> chipList = [];

    for (String label in convertDynamicListToStringList(dynamicLabels)) {
      chipList.add(
        _buildChipWithLabel(label, context),
      );
    }
    return chipList;
  }

  Chip _buildChipWithLabel(String label, BuildContext context) => Chip(
        label: Text(
          label,
          style: Theme.of(context).textTheme.body1,
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        backgroundColor: Theme.of(context).cardColor,
      );

  CachedNetworkImage _loadRecipeImageOrDefault(BuildContext context) {
    var backgroundImageUrl = FirestoreDocumentDataProvider.of(context)
        .documentData['backgroundImage'];
    var recipeType =
        FirestoreDocumentDataProvider.of(context).documentData['type'];

    assert(backgroundImageUrl is String);
    if (recipeType != null) {
      assert(recipeType is String);
    }

    return CachedNetworkImage(
      imageUrl: backgroundImageUrl?.trim(),
      errorWidget: (context, url, err) =>
          _getDefaultImageFromRecipeType(recipeType),
      placeholder: (context, url) => LinearProgressIndicator(
            backgroundColor: Theme.of(context).accentColor,
          ),
      fadeInCurve: Curves.decelerate,
      fadeInDuration: Duration(microseconds: 300),
        fit: BoxFit.cover,
    );
  }

  Image _getDefaultImageFromRecipeType(String type) {
    if (type != null) {
      switch (type.trim().toLowerCase()) {
        case 'salad':
          return _getAssetImage('salad.jpg');
        case 'soup':
          return _getAssetImage('soup.jpg');
        case 'vegetable':
          return _getAssetImage('vegetable.jpg');
        case 'roast':
          return _getAssetImage('roast.jpg');
        case 'stew':
          return _getAssetImage('stew.jpg');
        case 'pizza':
          return _getAssetImage('pizza.jpg');
        case 'sandwich':
          return _getAssetImage('sandwich.jpg');
        case 'wrap':
          return _getAssetImage('wrap.jpg');
        case 'pie':
          return _getAssetImage('pie.jpg');
        case 'fish':
          return _getAssetImage('fish.jpg');
        case 'beef':
          return _getAssetImage('beef.jpg');
        case 'chicken':
          return _getAssetImage('chicken.jpg');
        case 'curry':
          return _getAssetImage('curry.jpg');
        case 'eggs':
          return _getAssetImage('eggs.jpg');
        default:
          return _getAssetImage('default.jpg');
      }
    }
    return _getAssetImage('default.jpg');
  }

  Image _getAssetImage(String name) =>
      Image.asset("assets/images/recipes/" + name, fit: BoxFit.cover);
}
