import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:prep/utils/query.dart';
import 'package:prep/widgets/appointment_prep/category_card.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';

class AppointmentPrep extends StatefulWidget {
  AppointmentPrep();

  @override
  _AppointmentPrepState createState() => _AppointmentPrepState();
}

class _AppointmentPrepState extends State<AppointmentPrep> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Queries.prepCardsSnapshots,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            );
          } else {
            if (snapshot.data.documents != null && snapshot.data.documents.length > 0) {
              return StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(10.0),
                crossAxisCount: 4,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildGrid(context, snapshot.data.documents[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              );
            } else {
              return EmptyScreenPlaceholder(
                  "There is no preparation information", "");
            }
          }
        });
  }

  Widget _buildGrid(BuildContext context, DocumentSnapshot document) {
    return CategoryCard(document.documentID, document['title'],
        document['type'], Colors.white, Queries.dateTime);
  }
}
