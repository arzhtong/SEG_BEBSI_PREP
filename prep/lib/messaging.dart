import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// appointmentID needs to be stored with appointment info when added
final String appointmentID = "fe7sdGe2";

class Messaging extends StatefulWidget {
  @override
  State createState() => new MessagingWindow();
}

class MessagingWindow extends State<Messaging> with TickerProviderStateMixin {
  final MessagingQueries _queries = new MessagingQueries();
  final TextEditingController _textController = new TextEditingController();
  bool _hasTyped = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(children: <Widget>[
        new Flexible(
          child: _queries.messagesStream(),
        ),
        new Divider(height: 1.0),
        new Container(
          child: Row(children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (string) {
                  setState(() {
                    //TODO (unimportant) create a better metric
                    _hasTyped = string.length > 0;
                  });
                },
              ),
            ),
            new Container(
              child: new IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _hasTyped ? _queries.sendMessage(_textController.text) : null;
                  setState(() {
                    _hasTyped = false;
                    _textController.clear();
                  });
                },
              ),
            )
          ]),
        ),
      ]),
    );
  }
}

class Message extends StatelessWidget {
  Message(this.messageText, this.timestamp, this.isPatient);
  final String messageText;
  // timestamp not used at the moment
  final DateTime timestamp;
  final bool isPatient;

  @override
  Widget build(BuildContext context) {
    Alignment alignmentMessage = (isPatient) ? Alignment.centerRight : Alignment.centerLeft;

    return new Container(
      margin: const EdgeInsets.only(top: 6.0),
      child: new Text(messageText),
      alignment: alignmentMessage,
    );
  }
}

class MessagingQueries {

  static const MessagingQueries _singleton = MessagingQueries._internal();

  factory MessagingQueries() => _singleton;

  const MessagingQueries._internal();

  static final CollectionReference _colRef = Firestore.instance
      .collection('chats')
      .document(appointmentID)
      .collection('messages');

  static final Stream<QuerySnapshot> _snapshots = _colRef
      .orderBy('datetime', descending: true)
      .snapshots();

  void sendMessage(String message) {
    _colRef.add({
      'message': message,
      'datetime': DateTime.now(),
      'isPatient': true,
    });
  }

  StreamBuilder<QuerySnapshot> messagesStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: _snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {  
          //TODO (for production) print to console log.
          return new Text('Error: ${snapshot.error}');
        }

        switch  (snapshot.connectionState) {
          // waiting case may be removed when reading from cache is implemented
          case ConnectionState.waiting:
            return _messageListView(null);

          default:
            List<Widget> children = snapshot.data.documents.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> map = document.data;
                return new Message(
                    map['message'], map['datetime'], map['isPatient']
                  );
              }
            ).toList();
            return _messageListView(children);
        }
      }
    );
  }

  ListView _messageListView(List<Widget> childrenIn) {
    bool isReverse = true;
    EdgeInsets insets = new EdgeInsets.all(6.0);

    return (childrenIn == null)
      ? new ListView(reverse: isReverse, padding: insets)
      : new ListView(reverse: isReverse, padding: insets, children: childrenIn);
  }
}

