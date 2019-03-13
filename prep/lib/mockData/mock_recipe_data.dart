import 'package:flutter/material.dart';

final mockRecipeList = <RecipeMockUp>[
  RecipeMockUp(
    title: "Scrambled Eggs\nmade with Cream and Butter",
    backgroundImage: AssetImage('assets/images/recipes/eggs.jpg'),
    method: <String>[
      "You can make scrambled eggs in a pan or a microwave.",
      "Whisk two eggs with a tablespoon of cream.",
      "Add a knob of butter and stir until cooked.",
      "Serve with some chopped tomatoes and cucumber, or tomato quarters fried in a little oil.",
    ],
    note: "You MUST NOT add milk! Cream is optional.",
    ingredients: <String>[
      "2 eggs",
      "1 tablespoon cream (optional)",
      "2 tablespoons butter",
    ],
  ),
  RecipeMockUp(
      title: "Jerk Chicken and Salad",
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
  RecipeMockUp(
    title: "Fried Mushrooms",
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
  RecipeMockUp(
      title: "Fish and Vegetables\nin a Herb Cream Sauce",
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

class RecipeMockUp {
  final String title;
  final ImageProvider backgroundImage;
  final List<String> method;
  final List<String> ingredients;
  final String note;

  RecipeMockUp(
      {@required this.title,
      @required this.backgroundImage,
      @required this.method,
      @required this.ingredients,
      @required this.note});
}
