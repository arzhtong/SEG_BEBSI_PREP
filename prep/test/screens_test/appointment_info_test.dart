import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep/utils/query.dart';
import 'package:prep/screens/appointment_info.screen.dart';
import 'package:prep/utils/backend_provider.dart';

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

  List<Map<String, dynamic>> maps = new List();

  maps.add({
    'description': '<p>hello</p>',
    'name': 'This is the name'
  });

  Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

  testWidgets('Dependency injection test', (WidgetTester tester) async {
    MockBackend mockBackend = new MockBackend();
    when(mockBackend.testSnapshots).thenAnswer((_) => mapStream);

    AppointmentInfo appointmentInfo = AppointmentInfo();

    await tester.pumpWidget(testableWidget(backend: mockBackend, child: appointmentInfo));
    await tester.pump(Duration.zero);
  });
}