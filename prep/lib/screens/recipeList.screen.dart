import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prep/utils/prep_custom_icons.dart';

const String testID = "VyyiBYwp0xX4nJyvX9oN";

final _mockRecipeList = <_RecipeMockUp>[
  _RecipeMockUp(
    name: "Fried Mushrooms",
    backgroundImage: AssetImage('assets/images/recipes/mushrooms.jpg'),
    method: <String>[
      "Cook some sliced mushrooms in butter and garlic, frying some tomato quarters on the side.",
      "Serve with fried eggs and bacon, or a lamb chop."
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
      note:
          "You cannot thicken the sauce with flour or cornflour as these are not permitted."),
  _RecipeMockUp(
    name: "Scrambled Eggs\nmade with Cream and Butter",
    backgroundImage: AssetImage('assets/images/recipes/eggs.jpg'),
    method: <String>[
      "You can make scrambled eggs in a pan or a microwave.",
      "Whisk two eggs with a tablespoon of cream.",
      "Add a knob of butter and stir until cooked.",
      "Serve with some chopped tomatoes and cucumber, or tomato quarters fried in a little oil.",
    ],
    note: "You MUST NOT add milk! Cream is optional.",
  ),
  _RecipeMockUp(
      name: "Jerk Chicken and Salad",
      backgroundImage: AssetImage('assets/images/recipes/chicken.jpg'),
      method: <String>[
        "Marinade chicken pieces overnight in home-made jerk sauce.",
        "Make the jerk sauce by mixing together chopped spring onions, grated ginger, chopped garlic, chopped scotch bonnet chillies, dried thyme, a teaspoon of allspice, salt and pepper, and vegetable oil.",
        "You can fry bake or barbeque the chicken pieces, and serve with salad."
      ],
      note:
          "you MUST NOT add sugar, flour, lemon or lime juice to jerk seasoning!"),
];

class _RecipeMockUp {
  final String name;
  final ImageProvider backgroundImage;
  final List<String> method;
  final String note;

  _RecipeMockUp({this.name, this.backgroundImage, this.method, this.note});
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

          return RecipeCardExpandable(
            title: recipe.name,
            backgroundImage: recipe.backgroundImage,
            method: recipe.method,
            note: recipe.note,
          );
        },
        itemCount: _mockRecipeList.length,
      ),
    );
  }
}

class RecipeCardExpandable extends StatefulWidget {
  final ImageProvider backgroundImage;
  final String title;
  final List<String> method;
  final String note;

  RecipeCardExpandable(
      {@required this.title,
      @required this.backgroundImage,
      @required this.method,
      @required this.note});

  _RecipeCardExpandableState createState() => _RecipeCardExpandableState();
}

class _RecipeCardExpandableState extends State<RecipeCardExpandable> {
  bool isFavorited;
  bool isExpanded;

  @override
  void initState() {
    isExpanded = false;
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
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                this.isExpanded = !isExpanded;
              });
            },
            children: <ExpansionPanel>[
              new ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) =>
                    _buildCardHeaderContent(),
                body: RecipeCardBodyContent(
                  method: widget.method,
                  note: widget.note,
                ), //Add body biulder
                isExpanded: this.isExpanded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Build Recipe Card Header along with the card's favourite icon button
  Widget _buildCardHeaderContent() {
    return Stack(
      children: <Widget>[
        //Header content
        RecipeCardHeaderContent(
          backgroundImage: widget.backgroundImage,
          title: widget.title,
        ),
        //Favorite Icon Button
        Positioned(
          top: 10.0,
          right: 10.0,
          child: IconButton(
            iconSize: 30.0,
            onPressed: () {
              print("${widget.title} WAS FAVED!");

              setState(() {
                isFavorited = !isFavorited;
              });
            },
            //TODO: Change colors to Theme colors.
            icon: Icon(
              (isFavorited) ? Icons.favorite : Icons.favorite_border,
              color: (isFavorited)
                  ? Colors.redAccent
                  : Theme.of(context).disabledColor.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}

class RecipeCardHeaderContent extends StatelessWidget {
  static const double _backgroundImageBlurFactor = 2;
  static const double _backgroundImageDimOpacity = 0.3;

  final AssetImage backgroundImage;
  final String title;

  RecipeCardHeaderContent({this.title, this.backgroundImage})
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
          //Dim and blur the image
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: _backgroundImageBlurFactor,
                  sigmaY: _backgroundImageBlurFactor),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          ),
          //Recipe name
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

class RecipeCardBodyContent extends StatefulWidget {
  final List<String> method;
  final String note;
  RecipeCardBodyContent({this.method, this.note});

  @override
  State<StatefulWidget> createState() => _RecipeCardBodyContentState();
}

class _RecipeCardBodyContentState extends State<RecipeCardBodyContent>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Tab _biuldTabWithName(String name) {
    return Tab(
      child: Text(
        name,
        style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 18.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //FIXME: TabBar displays, but adding TabBarView makes the whole columb dissappear.
    /* return  Column(
      children: <Widget>[
        TabBar(
          tabs: <Widget>[
            _biuldTabWithName("Method"),
            _biuldTabWithName("Ingresients"),
          ],
          controller: _tabController,
        ),
        TabBarView(
          children: <Widget>[_buildRecipeCardBodyContent(), Text("BLOB")],
          controller: _tabController,
        ),
      ],
    ); */

    return _buildRecipeCardBodyContent();
  }

  Widget _buildRecipeCardBodyContent() {
    return Column(
      children: [
        _buildMethodInstructions(widget.method),
        <Widget>[
          RecipeNote(
            note: widget.note,
          )
        ]
      ].expand((x) => x).toList(),
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
      } else {
        retVal.add(
          SizedBox(
            height: 16.0,
          ),
        );
      }
    }

    return retVal;
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
          ),
        ),
        backgroundColor: Colors.black12, //TODO: Use theme colors
        foregroundColor: Colors.black,
      ),
      title: Text(
        instruction,
        style: TextStyle(fontSize: 18.0),
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
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
