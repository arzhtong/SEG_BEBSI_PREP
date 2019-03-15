import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/widgets/recipe/recipe_card_body.dart';
import 'package:prep/widgets/recipe/recipe_card_header.dart';

class RecipeCard extends StatelessWidget {
  final DocumentSnapshot snapshot;

  RecipeCard({@required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return FirestoreDocumentDataProvider(
      documentData: snapshot.data,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Material(
          child: Card(
            elevation: 1.0,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                RecipeCardHeader(),
                RecipeCardBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
