import 'package:flutter/material.dart';

import 'package:prep/widgets/recipe/recipe_card.dart';
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

//TODO: Add filter by favorite functionality
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
