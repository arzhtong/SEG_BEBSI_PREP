import 'package:flutter/material.dart';
import 'package:prep/utils/prep_custom_icons.dart';

const String testID = "VyyiBYwp0xX4nJyvX9oN";

final List<RecipeMockUp> recipeList = [
  RecipeMockUp(
    name: "Fried Mushrooms",
    backgroundImage: AssetImage('assets/images/recipes/mushrooms.jpg'),
  ),
  RecipeMockUp(
    name: "Fish and Vegetables\nin a Herb Cream Sauce",
    backgroundImage: AssetImage('assets/images/recipes/fish.jpg'),
  ),
  RecipeMockUp(
    name: "Scrambled Eggs\nmade with Cream and Butter",
    backgroundImage: AssetImage('assets/images/recipes/eggs.jpg'),
  ),
  RecipeMockUp(
    name: "Jerk Chicken and Salad",
    backgroundImage: AssetImage('assets/images/recipes/chicken.jpg'),
  ),
];

class RecipeMockUp {
  final String name;
  final ImageProvider backgroundImage;

  RecipeMockUp({this.name, this.backgroundImage});
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
          RecipeMockUp recipe = recipeList[index];

          return RecipeListItem(
            title: recipe.name,
            backgroundImage: recipe.backgroundImage,
          );
        },
        itemCount: recipeList.length,
      ),
    );
  }
}

class RecipeListItem extends StatefulWidget {
  final ImageProvider backgroundImage;
  final String title;
  RecipeListItem({this.backgroundImage, this.title});

  _RecipeListItemState createState() => _RecipeListItemState();
}

class _RecipeListItemState extends State<RecipeListItem> {
  bool isStarred = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              child: Card(
                elevation: 1.0,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    print(
                        "${widget.title} WAS PRESSED!"); //TODO: Navigate to correct recipie screen.
                  },
                  child: Stack(
                    children: <Widget>[
                      RecipeCardContent(
                        backgroundImage: widget.backgroundImage,
                        title: widget.title,
                      ),
                      Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: IconButton(
                          iconSize: 30.0,
                          onPressed: () {
                            print("${widget.title} WAS STARED!");

                            setState(() {
                              isStarred = !isStarred;
                            });
                          },
                          //TODO: Change colors to Theme colors.
                          icon: Icon(
                            (isStarred)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: (isStarred) ? Colors.redAccent : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeCardContent extends StatelessWidget {
  final AssetImage backgroundImage;
  final String title;

  RecipeCardContent({this.title, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.0,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Ink.image(
              image: backgroundImage,
              fit: BoxFit.cover,
              child: Container(),
            ),
          ),
          //Dim the image
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black45,
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                maxLines: 2,
                style: Theme.of(context).textTheme.subhead.copyWith(
                      color: Colors.white,
                      fontSize: 27.0,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
