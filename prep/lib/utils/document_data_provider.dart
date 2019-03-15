import 'package:flutter/material.dart';

///Provides a docuemnt snapshot instnace to pass down a widget tree
///in order to avoid passing it down through the constructor.
///Should be used within a strambuilder which sould handle the document updates.
class FirestoreDocumentDataProvider extends InheritedWidget {
  final Map<String, dynamic> documentData;

  FirestoreDocumentDataProvider(
      {Key key, @required Widget child, @required this.documentData})
      : super(key: key, child: child);

  //TODO: Firestore On document snapshot change.
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FirestoreDocumentDataProvider)
        as FirestoreDocumentDataProvider;
  }
}
