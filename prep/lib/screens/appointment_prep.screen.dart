import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/backend.dart';
import 'package:prep/widgets/appointment_prep/category_card.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';

class AppointmentPrep extends StatelessWidget {
  bool seenRecipe;
  bool seenFAQ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: BackendProvider.of(context).backend.prepCardsSnapshots,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            );
          } else {
            if (snapshot.data.documents != null &&
                snapshot.data.documents.length > 0) {
              seenFAQ = false;
              seenRecipe = false;
              return StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(7.5),
                crossAxisCount: 4,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildGrid(context, snapshot.data.documents[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              );
            } else {
              return EmptyScreenPlaceholder(
                  "There is no preparation information", "");
            }
          }
        });
  }

  Widget _buildGrid(BuildContext context, DocumentSnapshot document) {
    if (document['type'] == 'article' || document['type'] == 'categoryList') {
      return CategoryCard(
          document.documentID, document['title'], document['type']);
    } else {
      if (document['type'] == 'faqs' && !seenFAQ) {
        seenFAQ = true;
        return CategoryCard(document.documentID, "Frequently Asked Questions",
            document['type']);
      }

      if (document['type'] == 'recipe' && !seenRecipe) {
        seenRecipe = true;
        return CategoryCard(
            document.documentID, "Suggested Recipes", document['type']);
      }
    }

    return Container(
      padding: EdgeInsets.all(0),
    );
  }
}
