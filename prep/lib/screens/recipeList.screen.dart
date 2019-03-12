import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prep/utils/prep_custom_icons.dart';

const String testID = "VyyiBYwp0xX4nJyvX9oN";

final _mockRecipeList = <_RecipeMockUp>[
  _RecipeMockUp(
      name: "Jerk Chicken and Salad",
      backgroundImage: AssetImage('assets/images/recipes/chicken.jpg'),
      method: <String>[
        "Make the jerk sauce by mixing together chopped spring onions, grated ginger, chopped garlic, chopped scotch bonnet chillies, dried thyme, a teaspoon of allspice, salt and pepper, and vegetable oil.",
        "Marinade chicken pieces overnight in home-made jerk sauce.",
        "You can fry bake or barbeque the chicken pieces, and serve with salad."
      ],
      ingredients: <String>[
        "1 handful of spring onions",
        "1 tablespoon of ginger (grated)",
        "2 cloves of garlic",
        "scotch bonnet chillies to taste",
        "dried thyme",
        "1 teaspoon of allspice",
        "salt",
        "pepper",
        "1-2 tablespoons of vegetable oil",
      ],
      note:
          "you MUST NOT add sugar, flour, lemon or lime juice to jerk seasoning!"),
  _RecipeMockUp(
    name: "Fried Mushrooms",
    backgroundImage: AssetImage('assets/images/recipes/mushrooms.jpg'),
    method: <String>[
      "Cook some sliced mushrooms in butter and garlic, frying some tomato quarters on the side.",
      "Serve with fried eggs and bacon, or a lamb chop."
    ],
    ingredients: <String>[
      "mushrooms",
      "butter",
      "garlic",
      "tomato",
      "eggs",
      "bacon/lamb chop"
    ],
    note: "Please remember processed meats including sausages are not allowed!",
  ),
  _RecipeMockUp(
      name: "Fish and Vegetables\nin a Herb Cream Sauce",
      backgroundImage: AssetImage('assets/images/recipes/fish.jpg'),
      method: <String>[
        "Wrap up a piece of cod, haddock or tilapia topped with lemon zest, crushed garlic, fresh herbs and olive oil in foil to make a sealed parcel.",
        "Bake the parcel in an oven dish for 20 minutes at 200° C.",
        "While the fish is cooking, slice plenty of peppers, leeks, mushrooms and courgettes, and sauté in oil for 5-10 minutes until they are cooked how you like them.",
        "Add 50ml cream and a handful of chopped fresh herbs, warm through, and serve with the fish."
      ],
      ingredients: <String>[
        "1 fillet of cod/haddock/tilapia",
        "1 lemon",
        "2 cloves of garlic",
        "fresh herbs of choice",
        "1 tablespoons of olive oil",
        "1-2 bell peppers",
        "1 leek",
        "150g of mushrooms",
        "1 courgette",
        "50ml of cream",
      ],
      note:
          "You cannot thicken the sauce with flour or cornflour as these are not permitted."),
];

class _RecipeMockUp {
  final String name;
  final ImageProvider backgroundImage;
  final List<String> method;
  final List<String> ingredients;
  final String note;

  _RecipeMockUp(
      {@required this.name,
      @required this.backgroundImage,
      @required this.method,
      @required this.ingredients,
      @required this.note});
}

class RecipeListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  bool isFilterEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suggested Recipes"),
        actions: <Widget>[
          //TODO: Implement recipe search!
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              PrepCustomIcons.favorite_half,
              //TODO: Use theme colors.
              color: (isFilterEnabled)
                  ? Colors.white
                  : Theme.of(context).disabledColor,
            ),
            onPressed: () {
              setState(
                () {
                  isFilterEnabled = !isFilterEnabled;
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          _RecipeMockUp recipe = _mockRecipeList[index];

          return RecipeCard(
            title: recipe.name,
            backgroundImage: recipe.backgroundImage,
            ingredients: recipe.ingredients,
            method: recipe.method,
            note: recipe.note,
          );
        },
        itemCount: _mockRecipeList.length,
      ),
    );
  }
}

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

class RecipeCardContent extends StatelessWidget {
  final List<String> ingredients;
  final List<String> method;
  final String note;

  RecipeCardContent({this.ingredients, this.method, this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        <Widget>[
          _buildIngredientList(ingredients, context),
          SizedBox(
            height: 16.0,
          ),
        ],
        _buildMethodInstructions(method),
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

  Widget _buildIngredientList(List<String> ingredients, BuildContext context) {
    List<Widget> _ingredientListItems = [];

    for (String ingredient in ingredients) {
      _ingredientListItems.add(
        RecipeIngredientListItem(ingredient),
      );
    }

    return ExpansionTile(
      title: Text(
        "Show ingredients",
        style: Theme.of(context).textTheme.button,
      ),
      children: _ingredientListItems,
      backgroundColor: Colors.black12,
      initiallyExpanded: false,
    );
  }

  List<Widget> _buildMethodInstructions(List<String> method) {
    List<Widget> retVal = [];

    for (int i = 0; i < method.length; i++) {
      retVal.add(
        RecipeInstruction(
          ordering: i + 1,
          instruction: method[i],
        ),
      );

      //add dividers and ending padding
      if (i != method.length - 1) {
        retVal.add(
          Divider(),
        );
      }
    }

    return retVal;
  }
}

class RecipeIngredientListItem extends StatelessWidget {
  final String ingredient;

  RecipeIngredientListItem(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 32.0),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.chevron_right),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            ingredient,
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).textTheme.body2.color,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class RecipeInstruction extends StatelessWidget {
  final String instruction;
  final int ordering;

  RecipeInstruction({@required this.ordering, @required this.instruction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          ordering.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.body2.color,
          ),
        ),
        backgroundColor: Colors.black12, //TODO: Use theme colors
      ),
      title: Text(
        instruction,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}

class RecipeNote extends StatelessWidget {
  static const String notePrefix = "Note:";
  final String note;

  RecipeNote({@required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Colors.red[400],
            Colors.red[700],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          "$notePrefix $note",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}
