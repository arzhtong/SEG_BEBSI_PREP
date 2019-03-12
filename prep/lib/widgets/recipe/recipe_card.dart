import 'package:flutter/material.dart';

import 'package:prep/widgets/recipe/recipe_card_body.dart';
import 'package:prep/widgets/recipe/recipe_card_image.dart';

//FIXME: manage the passing down of data thoughout the classes
class RecipeCard extends StatefulWidget {
  final ImageProvider backgroundImage;
  final String title;
  final List<String> ingredients;
  final List<String> method;
  final String note;

  RecipeCard(
      {@required this.title,
      @required this.backgroundImage,
      @required this.ingredients,
      @required this.method,
      @required this.note});

  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isFavorited;

  @override
  void initState() {
    isFavorited = false; //TODO: Get actual value from database
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Material(
        child: Card(
          elevation: 1.0,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              _buildCardImageAndUI(),
              RecipeCardBody(
                title: widget.title,
                ingredients: widget.ingredients,
                method: widget.method,
                note: widget.note,
              ),
            ],
          ),
        ),
      ),
    );
  }

  RawMaterialButton _buildFavoriteButton() {
    return RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
      onPressed: () {
        //TODO: Implement actual favoriting handling
        if (isFavorited)
          print("${widget.title} WAS UNFAVED!");
        else
          print("${widget.title} WAS FAVED!");

        setState(() {
          isFavorited = !isFavorited;
        });
      },
      child: Icon(
        (isFavorited) ? Icons.favorite : Icons.favorite_border,
        color:
            (isFavorited) ? Colors.redAccent : Theme.of(context).disabledColor,
      ),
      elevation: 2.0,
      fillColor: Colors.white,
      shape: CircleBorder(),
    );
  }

  //Build Recipe Card Header along with the card's favourite icon button
  Widget _buildCardImageAndUI() {
    return Stack(
      children: <Widget>[
        //Header content
        RecipeCardImage(
          backgroundImage: widget.backgroundImage,
        ),
        //Favorite Icon Button
        Positioned(
          top: 10.0,
          right: 10.0,
          child: _buildFavoriteButton(),
        ),
      ],
    );
  }
}
