import 'package:flutter/material.dart';

import 'package:prep/utils/query.dart';

///Provides an instance of and object that implements BaseBackend to pass down a widget tree
///in order to avoid passing it down through the constructor.
class BackendProvider extends InheritedWidget {
  final BaseBackend backend;

  BackendProvider({Key key, @required Widget child, @required this.backend})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BackendProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(BackendProvider) as BackendProvider;
}
