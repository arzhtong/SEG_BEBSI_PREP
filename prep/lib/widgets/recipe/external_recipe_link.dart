import 'package:flutter/material.dart';
import 'package:prep/utils/constants.dart';
import 'package:prep/utils/misc_functions.dart' show launchURL;

//TODO: Add link error validity chacking.
class ExternalRecipeLink extends StatelessWidget {
  final dynamic externalUrlData;

  ExternalRecipeLink(this.externalUrlData);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: const Text(
          Constants.kViewRecipeOnlineButtonText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () => launchURL(externalUrlData.toString()),
        color: Theme.of(context).accentColor,
        elevation: 4.0,
      ),
    );
  }
}
