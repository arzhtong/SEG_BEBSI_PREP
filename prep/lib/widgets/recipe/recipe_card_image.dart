import 'package:flutter/material.dart';
import "package:prep/utils/document_data_provider.dart";
import 'package:cached_network_image/cached_network_image.dart';

class RecipeCardImage extends StatelessWidget {
  static const double _backgroundImageBlurFactor = 2;
  static const double _backgroundImageDimOpacity = 0.3;

  RecipeCardImage()
      : assert(_backgroundImageBlurFactor >= 0),
        assert(_backgroundImageDimOpacity >= 0 &&
            _backgroundImageDimOpacity <= 1.0);

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
        ],
      ),
    );
  }

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
