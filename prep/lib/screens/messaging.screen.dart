import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:prep/utils/query.dart';
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
    Map<String, dynamic> message = document.data;
    if (!message['seenByPatient']) Queries.setSeenByPatient(document.reference);
    String decryptedMessage = MessageCrypto.decryptMessage(message['content']);

    _messagesView.addMessage(
      messageText: decryptedMessage,
      datetime: message['datetime'].toDate(),
      isPatient: message['isPatient'],
    );
  }

  @override
  void initState() {
    super.initState();

    _messageStreamSubscription =
        Queries.messageSnapshots.listen((QuerySnapshot snapshot) {
      snapshot.documentChanges.forEach((DocumentChange change) {
        if (change.type == DocumentChangeType.added)
          _addNewMessage(change.document);
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
