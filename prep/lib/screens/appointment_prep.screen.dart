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
        builder: (context, mapListSnapshot) {
          if (!mapListSnapshot.hasData) {
            return const Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            );
          } else {
            if (mapListSnapshot.data != null &&
                mapListSnapshot.data.length > 0) {
              seenFAQ = false;
              seenRecipe = false;
              return StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(7.5),
                crossAxisCount: 4,
                itemCount: mapListSnapshot.data.length,
                itemBuilder: (context, index) =>
                    _buildGrid(context, mapListSnapshot.data[index]),
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

  Widget _buildGrid(
      BuildContext context, Map<String, Map<String, dynamic>> docIdDataMap) {
    String docID = docIdDataMap.keys.first;
    Map<String, dynamic> dataMap = docIdDataMap[docIdDataMap.keys.first];

    if (dataMap['type'] == 'article' || dataMap['type'] == 'categoryList') {
      return CategoryCard(docID, dataMap['title'], dataMap['type']);
    } else {
      if (dataMap['type'] == 'faqs' && !seenFAQ) {
        seenFAQ = true;
        return CategoryCard(
            docID, "Frequently Asked Questions", dataMap['type']);
      }

      if (dataMap['type'] == 'recipe' && !seenRecipe) {
        seenRecipe = true;
        return CategoryCard(docID, "Suggested Recipes", dataMap['type']);
      }
    }

    return Container(
      padding: EdgeInsets.all(0),
    );
  }
}
