import 'package:flutter/material.dart';

class EmptyScreenPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;

  EmptyScreenPlaceholder(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 35.0,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        Padding(
          key: Key('padding'),
          padding: EdgeInsets.all(20.0),
        ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.grey,
            ),
          ),
        ],
      )
    );
  }
}