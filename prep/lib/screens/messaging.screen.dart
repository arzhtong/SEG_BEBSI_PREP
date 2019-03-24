import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/message_crypto.dart';
import 'package:prep/widgets/messaging/messages_view.dart';
import 'package:prep/widgets/messaging/text_composer.dart';

class MessagingScreen extends StatefulWidget {
  @override
  State createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  MessagesView _messagesView = MessagesView();
  TextComposer _textComposer = TextComposer();
  StreamSubscription<QuerySnapshot> _messageStreamSubscription;

  void _addNewMessage(DocumentSnapshot document) {
    final BaseBackend backend = BackendProvider.of(context).backend;

    Map<String, dynamic> message = document.data;
    if (!message['seenByPatient']) backend.setSeenByPatient(document.reference);
    String decryptedMessage =
        MessageCrypto.decryptMessage(backend.appointmentID, message['content']);

    _messagesView.addMessage(
      messageText: decryptedMessage,
      datetime: message['datetime'].toDate(),
      isPatient: message['isPatient'],
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _messageStreamSubscription = BackendProvider.of(context)
          .backend
          .messageSnapshots
          .listen((QuerySnapshot snapshot) {
        snapshot.documentChanges.forEach((DocumentChange change) {
          if (change.type == DocumentChangeType.added)
            _addNewMessage(change.document);
        });
      });
    });
  }

  @override
  void dispose() {
    _messageStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: <Widget>[
        _messagesView,
        Divider(height: 1.0),
        _textComposer,
      ]),
    );
  }
}
