import 'package:flutter/material.dart';

class RecipeMethodListItem extends StatelessWidget {
  final String instruction;
  final int ordering;

  RecipeMethodListItem({@required this.ordering, @required this.instruction});

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
