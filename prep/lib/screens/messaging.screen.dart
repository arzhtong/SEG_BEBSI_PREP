import 'package:flutter/material.dart';

import '../utils/query.dart';

class Messaging extends StatefulWidget {
  @override
  State createState() => new MessagingScreen();
}

class MessagingScreen extends State<Messaging> with TickerProviderStateMixin {
  final MessagingQueries _queries = new MessagingQueries();
  final TextEditingController _textController = new TextEditingController();
  bool _hasTyped = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(children: <Widget>[
        new Flexible(
          child: _messagesStream(MessagingQueries().messagesSnapshots),
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
                    _textController.clear();
                    _hasTyped = false;
                  });
                },
              ),
            )
          ]),
        ),
      ]),
    );
  }

    StreamBuilder<QuerySnapshot> _messagesStream(Stream<QuerySnapshot> snapshots) {
    return StreamBuilder<QuerySnapshot>(
        stream: snapshots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            //TODO (for production) print to console log.
            return new Text('Error: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            // waiting case may be removed when reading from cache is implemented
            case ConnectionState.waiting:
              return _messageListView(null);

            default:
              List<Widget> children =
                  snapshot.data.documents.map((DocumentSnapshot document) {
                Map<String, dynamic> map = document.data;
                return new _Message(
                    map['message'], map['datetime'], map['isPatient']);
              }).toList();
              return _messageListView(children);
          }
        });
  }

  ListView _messageListView(List<Widget> childrenIn) {
    bool isReverse = true;
    EdgeInsets insets = new EdgeInsets.all(6.0);

    return (childrenIn == null)
        ? new ListView(reverse: isReverse, padding: insets)
        : new ListView(
            reverse: isReverse, padding: insets, children: childrenIn);
  }
}

class _Message extends StatelessWidget {
  _Message(this.messageText, this.timestamp, this.isPatient);
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



