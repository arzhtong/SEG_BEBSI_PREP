import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';

import '../utils/query.dart';
import '../utils/message_crypto.dart';

class MessagingScreen extends StatefulWidget {
  @override
  State createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  _MessagesView _messagesView = _MessagesView();
  StreamSubscription<QuerySnapshot> _messageStreamSubscription;

  void _addNewMessage(DocumentSnapshot document) {
    Map<String, dynamic> message = document.data;
    if (!message['seenByPatient']) Queries.setSeenByPatient(document.reference);

    String decryptedMessage = MessageCrypto.decryptMessage(message['content']);

    // TODO: Remove seenByStaff, as the patient should not see read receipts
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
        Flexible(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: _messagesView,
          ),
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

  void addMessage({String messageText, DateTime datetime, bool isPatient}) {
    _messagesState._addMessageToList(
      messageText: messageText,
      datetime: datetime,
      isPatient: isPatient,
    );
  }

  @override
  State createState() => _messagesState;
}

class _MessagesViewState extends State<_MessagesView>
    with TickerProviderStateMixin {
  List<_MessageData> _messagesList = [];
  // final ScrollController _scrollController = ScrollController();

  void _addMessageToList(
      {String messageText, DateTime datetime, bool isPatient}) {
    AnimationController animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _MessageData _newMessage = _MessageData(
      messageText: messageText,
      datetime: datetime,
      isPatient: isPatient,
      animController: animController,
    );

    setState(() => _messagesList.insert(0, _newMessage));
    // _scrollMessageViewToBottom();
  }

  /* void _scrollMessageViewToBottom() => _scrollController.animateTo(0.0,
      curve: Curves.ease, duration: const Duration(milliseconds: 300)); */

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
      // controller: _scrollController,
    );
  }
}

class _TextComposer extends StatefulWidget {
  @override
  State createState() => _TextComposerState();
}

class _TextComposerState extends State<_TextComposer> {
  TextEditingController _textController = TextEditingController();
  bool _hasTyped = false;

  void _sendMessage(String messageText) {
    if (_hasTyped) {
      setState(() => _hasTyped = false);
      String encryptedMessage = MessageCrypto.encryptMessage(messageText);
      Queries.sendMessage(encryptedMessage);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        padding: EdgeInsets.only(left: 8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: SingleChildScrollView(
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
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        //TODO Change to proper theme colors after implementation.
                        color: (_hasTyped)
                            ? Theme.of(context).accentColor
                            : Theme.of(context).buttonColor,
                      ),
                      onPressed: () =>
                          _sendMessage(_textController.text.trim()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageData {
  final String messageText;
  final DateTime datetime;
  final bool isPatient;
  final AnimationController animController; //not yet used

  _MessageData(
      {@required this.messageText,
      @required this.datetime,
      @required this.isPatient,
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
              /* Icon(
                Icons.done,
                color: Theme.of(context).buttonColor,
                size: 16.0,
              ),
              Text(
                "Delivered",
                style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
              ), */
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
