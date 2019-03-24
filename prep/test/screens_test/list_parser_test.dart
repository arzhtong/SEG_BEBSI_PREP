import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/backend.dart';
import 'package:prep/screens/list_parser.screen.dart';

class MockBackend extends Mock implements FirestoreBackend {}

void main() {
  Widget testableWidget({MockBackend backend, Widget child}) {
    return BackendProvider(
      backend: backend,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Test desc', (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({
      'contents': "Allowed foods",
      'maps': [
        {
          '0': {
            'description': "Sample description",
            'list': ['item 1', 'item 2', 'item 3'],
            'name': "Sample name"
          }
        },
        {
          '1': {
            'description': "Sample description 2",
            'list': ['item 1', 'item 2', 'item 3'],
            'name': "Sample name 2"
          }
        }
      ],
      'title': "Allowed foods",
      'type': "categoryList"
    });

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.categoryListSnapshots("dummyDocumentID"))
        .thenAnswer((_) => mapStream);

    CategoryListParser categoryListParser =
        CategoryListParser("dummyDocumentID", "dummyTitle");

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: categoryListParser));
    await tester.pump(Duration.zero);
  });
}
