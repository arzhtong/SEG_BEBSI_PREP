import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/message_crypto.dart';
import 'package:prep/screens/messaging.screen.dart';

class MockBackend extends Mock implements BaseBackend {}

main() {
  final String mockAppointmentID = 'abcdefghi';
  List<Map<String, dynamic>> mockMessagesCollection = [];

  Widget testableWidget({MockBackend backend, Widget child}) {
    return BackendProvider(
      backend: backend,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  MockBackend setUpMockBackend() {
    MockBackend mockBackend = new MockBackend();
    List<Map<String, dynamic>> mockMessagesCollectionSent = [];

    when(mockBackend.appointmentID).thenReturn(
      mockAppointmentID,
    );

    when(mockBackend.messagesStream(any)).thenAnswer(
      (_) => Stream.periodic(Duration(milliseconds: 100), (_) {
            List<Map<String, dynamic>> mockMessagesCollectionToSend =
                mockMessagesCollection
                    .map((message) =>
                        (!mockMessagesCollectionSent.contains(message))
                            ? message
                            : null)
                    .where((message) => message != null)
                    .toList();
            mockMessagesCollectionSent.addAll(mockMessagesCollectionToSend);
            return mockMessagesCollectionToSend;
          }),
    );

    when(mockBackend.sendMessage(any)).thenAnswer((invocation) {
      mockMessagesCollection.add({
        'content': invocation.positionalArguments.first,
        'datetime': Timestamp.fromDate(DateTime.now()),
        'isPatient': true,
        'seenByPatient': true,
      });
    });

    return mockBackend;
  }

  Future<void> setUpWidgetTester(WidgetTester tester) async {
    MockBackend mockBackend = setUpMockBackend();
    MessagingScreen messagingScreen = MessagingScreen();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: messagingScreen));
    await tester.pumpAndSettle();
  }

  group('Messaging tests:', () {
    List<String> testMessages = [
      "First Test Message!",
      "Second Test Message!",
      "Third Test Message!",
      "Fourth Test Message!",
      "Fifth Test Message!",
    ];

    testWidgets('text field, send button, and messages view are found',
        (WidgetTester tester) async {
      await setUpWidgetTester(tester);

      final textField = find.byKey(Key('textField'));
      final sendButton = find.byKey(Key('sendButton'));
      final messagesView = find.byKey(Key('messagesView'));

      expect(textField, findsOneWidget);
      expect(sendButton, findsOneWidget);
      expect(messagesView, findsOneWidget);
    });

    testWidgets("messages can be encrypted and sent; encrypted messages can be received",
        (WidgetTester tester) async {
      await setUpWidgetTester(tester);

      final textField = find.byKey(Key('textField'));
      final sendButton = find.byKey(Key('sendButton'));
      final messagesView = find.byKey(Key('messagesView'));

      for (String message in testMessages) {
        await tester.enterText(textField, message);
        await tester.tap(sendButton);
        await tester.pumpAndSettle();

        ListView listView = (messagesView.evaluate().single.widget as ListView);

        expect(listView.semanticChildCount, mockMessagesCollection.length);
      }
    });

    test("received encrypted messages can be decrypted", () {
      List<String> decryptedMessages = mockMessagesCollection.map((message) {
        return MessageCrypto.decryptMessage(
          mockAppointmentID,
          message['content'],
        );
      }).toList();

      expect(decryptedMessages, testMessages);
    });
  });
}
