import 'package:flutter/material.dart';

import 'package:prep/widgets/recipe/recipe_card.dart';
import 'package:prep/widgets/recipe/recipe_card_body.dart';

/* bool debugCheckHasRecipeCard(BuildContext context) {
  assert(() {
    if (context.widget.runtimeType != RecipeCard &&
        context.ancestorWidgetOfExactType(RecipeCard) == null) {
      final StringBuffer message = StringBuffer();
      message.writeln('No RecipeCard widget found.');
      message
          .writeln('${context.widget.runtimeType} widgets require a RecipeCard '
              'widget ancestor.');
      message.writeln(
          '${context.widget.runtimeType} is an intrinsic part of a RecipeCard '
          'and therefore must only be used as its child.');
      message.writeln(
          'The specific widget that could not find a RecipeCard ancestor was:');
      message.writeln('  ${context.widget}');
      final List<Widget> ancestors = <Widget>[];
      context.visitAncestorElements((Element element) {
        ancestors.add(element.widget);
        return true;
      });
      if (ancestors.isNotEmpty) {
        message.write('The ancestors of this widget were:');
        for (Widget ancestor in ancestors) message.write('\n  $ancestor');
      } else {
        message.writeln('This widget is the root of the tree, so it has no '
            'ancestors, let alone a RecipeCard ancestor.');
      }
      throw FlutterError(message.toString());
    }
    return true;
  }());
  return true;
}

bool debugCheckHasRecipeCardBody(BuildContext context) {
  assert(() {
    if (context.widget.runtimeType != RecipeCardContent &&
        context.ancestorWidgetOfExactType(RecipeCardContent) == null) {
      final StringBuffer message = StringBuffer();
      message.writeln('No RecipeCardBody widget found.');
      message.writeln(
          '${context.widget.runtimeType} widgets require a RecipeCardBody '
          'widget ancestor.');
      message.writeln(
          '${context.widget.runtimeType} is an intrinsic part of a RecipeCardBody '
          'and therefore must only be used as its child.');
      message.writeln(
          'The specific widget that could not find a RecipeCardBody ancestor was:');
      message.writeln('  ${context.widget}');
      final List<Widget> ancestors = <Widget>[];
      context.visitAncestorElements((Element element) {
        ancestors.add(element.widget);
        return true;
      });
      if (ancestors.isNotEmpty) {
        message.write('The ancestors of this widget were:');
        for (Widget ancestor in ancestors) message.write('\n  $ancestor');
      } else {
        message.writeln('This widget is the root of the tree, so it has no '
            'ancestors, let alone a RecipeCardBody ancestor.');
      }
      throw FlutterError(message.toString());
    }
    return true;
  }());
  return true;
}

bool debugCheckHasRecipeCardContent(BuildContext context) {
  assert(() {
    if (context.widget.runtimeType != RecipeCardContent &&
        context.ancestorWidgetOfExactType(RecipeCardContent) == null) {
      final StringBuffer message = StringBuffer();
      message.writeln('No RecipeCardContent widget found.');
      message.writeln(
          '${context.widget.runtimeType} widgets require a RecipeCardContent '
          'widget ancestor.');
      message.writeln(
          '${context.widget.runtimeType} is an intrinsic part of a RecipeCardContent '
          'and therefore must only be used as its child.');
      message.writeln(
          'The specific widget that could not find a RecipeCardContent ancestor was:');
      message.writeln('  ${context.widget}');
      final List<Widget> ancestors = <Widget>[];
      context.visitAncestorElements((Element element) {
        ancestors.add(element.widget);
        return true;
      });
      if (ancestors.isNotEmpty) {
        message.write('The ancestors of this widget were:');
        for (Widget ancestor in ancestors) message.write('\n  $ancestor');
      } else {
        message.writeln('This widget is the root of the tree, so it has no '
            'ancestors, let alone a RecipeCardContent ancestor.');
      }
      throw FlutterError(message.toString());
    }
    return true;
  }());
  return true;
} */
