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
  StreamSubscription<List<Map<String, dynamic>>> _messageStreamSubscription;

  void _addNewMessage(Map<String, dynamic> message) {
    String decryptedMessage = MessageCrypto.decryptMessage(
        BackendProvider.of(context).backend.appointmentID, message['content']);

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
          .messagesStream(setSeen: true)
          .listen((list) => list.forEach((message) => _addNewMessage(message)));
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
