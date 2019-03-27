import 'package:flutter/material.dart';

///Provides a docuemnt snapshot instnace to pass down a widget tree
///in order to avoid passing it down through the constructor.
///Should be used within a strambuilder which sould handle the document updates.
class DocumentDataProvider extends InheritedWidget {
  final Map<String, dynamic> documentData;

  DocumentDataProvider(
      {Key key, @required Widget child, @required this.documentData})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(DocumentDataProvider)
          as DocumentDataProvider;
}
