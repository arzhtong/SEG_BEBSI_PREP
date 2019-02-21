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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(children: <Widget>[
        new Flexible(
          child: _queries.messagesStream(),
        ),
        new Divider(height: 1.0),
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
  final Stream<QuerySnapshot> snapshots = Firestore.instance.collection('chats')
                                                            .document(appointmentID)
                                                            .collection('messages')
                                                            .orderBy('datetime', descending: true)
                                                            .snapshots();

  StreamBuilder<QuerySnapshot> messagesStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) { return new Text('Error: ${snapshot.error}'); }

        switch(snapshot.connectionState) {
          // waiting case may be removed when reading from cache is implemented
          case ConnectionState.waiting:
            return _messageListView(null);

          default:
            List<Widget> children = snapshot.data.documents.map((DocumentSnapshot document) {
              Map<String, dynamic> map = document.data;
              return new Message(map['message'], map['datetime'], map['isPatient']);
            }).toList();
            return _messageListView(children);
        }
      }
    );
  }

  ListView _messageListView(List<Widget> childrenIn) {
    bool isReverse = true;
    EdgeInsets insets = new EdgeInsets.all(6.0);

    return (childrenIn == null) ? new ListView(reverse: isReverse, padding: insets)
                                : new ListView(reverse: isReverse, padding: insets, children: childrenIn);
  }
}