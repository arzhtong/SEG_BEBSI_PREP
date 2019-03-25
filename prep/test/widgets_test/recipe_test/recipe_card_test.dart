import 'package:flutter/material.dart';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep/widgets/recipe/recipe_card.dart';

class MockRecipeCardData extends Mock implements Map<String, dynamic> {
  static const String validTitle = 'valid title';

  static const String validSubtitle = 'valid subtitle';

  static const List<String> validLabels = <String>[
    'valid label 1',
    'valid label 2',
    'valid label 3',
  ];

  static const List<String> validIngredients = <String>[
    'valid ingredint 1',
    'valid ingredint 2',
    'valid ingredint 3',
  ];

  static const List<String> validMethod = <String>[
    'valid instruction 1',
    'valid instruction 2',
    'valid instruction 3',
  ];

  static const String validNote = 'valid note';

  static final Finder validTitleFinder = find.text(validTitle);
  static final Finder validSubtitleFinder = find.text(validSubtitle);

  static final Finder validLabel1Finder = find.text(validLabels[0]);
  static final Finder validLabel2Finder = find.text(validLabels[1]);
  static final Finder validLabel3Finder = find.text(validLabels[2]);

  static final Finder ingredientTileFinder = find.byKey(Key('ingredientList'));

  static final Finder validIngredient1Finder = find.text(validIngredients[0]);
  static final Finder validIngredient2Finder = find.text(validIngredients[1]);
  static final Finder validIngredient3Finder = find.text(validIngredients[2]);

  static final Finder validInstruction1Finder = find.text(validMethod[0]);
  static final Finder validInstruction2Finder = find.text(validMethod[1]);
  static final Finder validInstruction3Finder = find.text(validMethod[2]);

  static final Finder validNoteFinder = find.text(validNote);

  static final Finder urlButtonFinder = find.byKey(Key('externalUrlButton'));

  static final Finder expansionTileButtonFinder =
      find.byKey(Key('recipeCardBody'));

  MockRecipeCardData configure({
    String backgroundImage,
    @required String title,
    String subtitle,
    List<String> labels,
    List<String> ingredients,
    List<String> method,
    String note,
    String recipeType = 'default',
    String externalUrl,
  }) {
    when(this['backgroundImage']).thenReturn(backgroundImage);
    when(this['title']).thenReturn(title);
    when(this['subtitle']).thenReturn(subtitle);
    when(this['labels']).thenReturn(labels);
    when(this['ingredients']).thenReturn(ingredients);
    when(this['method']).thenReturn(method);
    when(this['note']).thenReturn(note);
    when(this['externalURL']).thenReturn(externalUrl);
    when(this['recipeType']).thenReturn(recipeType);

    return this;
  }

  MockRecipeCardData configureValid() => configure(
        title: validTitle,
        subtitle: validSubtitle,
        labels: validLabels,
        ingredients: validIngredients,
        method: validMethod,
        externalUrl: 'http://example.com',
        note: validNote,
      );
}

void main() {
  Widget makeTestableWidget(Widget child) => MaterialApp(home: child);

  testWidgets(
    'RecipeCard with all data fields set and valid should build each of them',
    (WidgetTester tester) async {
      final MockRecipeCardData mockRecipeCardData =
          MockRecipeCardData().configureValid();

      final RecipeCard cardToTest = RecipeCard(
        data: mockRecipeCardData,
      );

      await tester.pumpWidget(makeTestableWidget(cardToTest));

      await tester.tap(MockRecipeCardData.expansionTileButtonFinder);
      await tester.pump();
      await tester.tap(MockRecipeCardData.ingredientTileFinder);
      await tester.pump();

      //expect that they are found exacty once

      expect(MockRecipeCardData.validTitleFinder, findsOneWidget);
      expect(MockRecipeCardData.validSubtitleFinder, findsOneWidget);

      expect(MockRecipeCardData.validLabel1Finder, findsOneWidget);
      expect(MockRecipeCardData.validLabel2Finder, findsOneWidget);
      expect(MockRecipeCardData.validLabel3Finder, findsOneWidget);

      /*      expect(MockRecipeCardData.validIngredient1Finder, findsOneWidget);
      expect(MockRecipeCardData.validIngredient2Finder, findsOneWidget);
      expect(MockRecipeCardData.validIngredient3Finder, findsOneWidget);

      expect(MockRecipeCardData.validInstruction1Finder, findsOneWidget);
      expect(MockRecipeCardData.validInstruction2Finder, findsOneWidget);
      expect(MockRecipeCardData.validInstruction3Finder, findsOneWidget);
 */

      expect(MockRecipeCardData.urlButtonFinder, findsOneWidget);

      //expect(MockRecipeCardData.validNote, findsOneWidget);
    },
  );
}
