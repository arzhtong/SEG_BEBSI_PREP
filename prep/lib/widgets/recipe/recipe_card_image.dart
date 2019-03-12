import 'package:flutter/material.dart';

class RecipeCardImage extends StatelessWidget {
  static const double _backgroundImageBlurFactor = 2;
  static const double _backgroundImageDimOpacity = 0.3;

  final AssetImage backgroundImage;

  RecipeCardImage({this.backgroundImage})
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
            child: Ink.image(
              image: backgroundImage,
              fit: BoxFit.cover,
              child: Container(),
            ),
          ),
          //TODO: Dim and blur when the tile is expanded.
          //Dim and blur the image
          /* Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: _backgroundImageBlurFactor,
                  sigmaY: _backgroundImageBlurFactor),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          ), */
        ],
      ),
    );
  }
}
