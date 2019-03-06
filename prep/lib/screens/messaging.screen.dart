import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';

import '../utils/query.dart';
import '../utils/message_crypto.dart';


class MessagingScreen extends StatefulWidget {
  final _MessagingScreenState _messagingScreenState = _MessagingScreenState();

  @override
  State createState() => _messagingScreenState;
}

class _MessagingScreenState extends State<MessagingScreen> {
  final _MessagesView _messagesView = _MessagesView();
  StreamSubscription<QuerySnapshot> _messageStreamSubscription;

  void _addNewMessage(DocumentSnapshot document) {
    Map<String, dynamic> message = document.data;
    if (!message['seenByPatient'])
      MessagingQueries.setSeenByPatient(document.reference);

    String decryptedMessage = MessageCrypto.decryptMessage(
        message['content'], message['datetime'].millisecondsSinceEpoch);

    _messagesView.addMessage(
      messageText: decryptedMessage,
      datetime: message['datetime'],
      isPatient: message['isPatient'],
      seenByStaff: message['seenByStaff'],
    );
  }

  @override
  void initState() {
    super.initState();
    _messageStreamSubscription =
        MessagingQueries.messageSnapshots.listen((QuerySnapshot snapshot) {
      snapshot.documentChanges.forEach((DocumentChange change) {
        print("CHANGE DETECTED");        
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
      appBar: AppBar(
        title: Text("Doctor"),
      ),
      body: Column(children: <Widget>[
        Flexible(
          child: _messagesView,
        ),
        Divider(height: 1.0),
        Container(
          child: _TextComposer(),
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
        ),
      ]),
    );
  }
}

class _MessagesView extends StatefulWidget {
  final _MessagesViewState _messagesState = _MessagesViewState();

  void addMessage(
      {String messageText,
      DateTime datetime,
      bool isPatient,
      bool seenByStaff}) {
    _messagesState._addMessageToList(
      messageText: messageText,
      datetime: datetime,
      isPatient: isPatient,
      seenByStaff: seenByStaff,
    );
  }

  @override
  State createState() => _messagesState;
}

class _MessagesViewState extends State<_MessagesView>
    with TickerProviderStateMixin {
  List<_MessageData> _messagesList = [];
  final ScrollController _scrollController = ScrollController();

  void _addMessageToList(
      {String messageText,
      DateTime datetime,
      bool isPatient,
      bool seenByStaff}) {
    AnimationController animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _MessageData _newMessage = _MessageData(
      messageText: messageText,
      datetime: datetime,
      isPatient: isPatient,
      seenByStaff: seenByStaff,
      animController: animController,
    );

    setState(() => _messagesList.insert(0, _newMessage));
    _scrollMessageViewToBottom();
  }

  void _scrollMessageViewToBottom() => _scrollController.animateTo(0.0,
      curve: Curves.ease, duration: const Duration(milliseconds: 300));

  void dispose() {
    for (_MessageData message in _messagesList) {
      message.animController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemBuilder: (_, int index) => _MessageListItem(_messagesList[index]),
      itemCount: _messagesList.length,
      controller: _scrollController,
    );
  }
}

class _TextComposer extends StatefulWidget {
  @override
  State createState() => _TextComposerState();
}

class _TextComposerState extends State<_TextComposer> {
  final TextEditingController _textController = TextEditingController();
  bool _hasTyped = false;

  void _sendMessage(String messageText) {
    if (_hasTyped) {
      setState(() => _hasTyped = false);
      DateTime now = DateTime.now();
      String encryptedMessage =
          MessageCrypto.encryptMessage(messageText, now.millisecondsSinceEpoch);
      MessagingQueries.sendMessage(encryptedMessage, now);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _textController,
                onChanged: (userInputText) {
                  setState(() => _hasTyped = userInputText.length > 0);
                },
                //onSubmitted: MessagingQueries.sendMessage,
                decoration:
                    InputDecoration.collapsed(hintText: "Type a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  //TODO Change to proper theme colors after implementation.
                  color: (_hasTyped)
                      ? Theme.of(context).accentColor
                      : Theme.of(context).buttonColor,
                ),
                onPressed: () => _sendMessage(_textController.text.trim()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageData {
  final String messageText;
  final DateTime datetime;
  final bool seenByStaff;
  final bool isPatient;
  final AnimationController animController; //not yet used

  _MessageData(
      {@required this.messageText,
      @required this.datetime,
      @required this.isPatient,
      @required this.seenByStaff,
      this.animController});
}

//Widget used to display a particlat message on screen
class _MessageListItem extends StatelessWidget {
  final _MessageData message;

  _MessageListItem(this.message)
      : rowAlignment = (message.isPatient)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        messageBackgroundColor = (message.isPatient)
            ? Colors.greenAccent
            : Colors.lightBlueAccent; //TODO use Theme colors

  final MainAxisAlignment rowAlignment;
  final Color messageBackgroundColor;
  final bool shouldWrap = true; // not yet used...

  Widget _getStatusLine(BuildContext context) {
    var statuslineTimestamp = Text(
      message.datetime.toString().substring(10, 16),
      style: TextStyle(fontSize: 12.0),
    );

    return Row(
      mainAxisAlignment: rowAlignment,
      children: (message.isPatient)
          ? <Widget>[
              //Time sent
              statuslineTimestamp,
              //Read Receipt
              Icon(((message.seenByStaff) ? Icons.done_all : Icons.done),
                  color: (message.seenByStaff)
                      ? Theme.of(context).accentColor
                      : Theme.of(context).buttonColor,
                  size: 16.0)
            ]
          : <Widget>[
              //Time sent
              statuslineTimestamp
            ],
    );
  }

  Widget _getMessageBody(BuildContext context) {
    return Row(
      mainAxisAlignment: rowAlignment,
      children: <Widget>[
        Flexible(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: messageBackgroundColor,
              ),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message.messageText,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          _getStatusLine(context),
          _getMessageBody(context),
          Divider(),
        ],
      ),
    );
  }
}
