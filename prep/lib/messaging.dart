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
      body: _queries.messagesStream(),
    );
  }
}

class Message extends StatelessWidget {
  Message(this.messageText);
  final String messageText;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.only(top: 6.0),
      child: new Text(messageText),
    );
  }
}

class MessagingQueries {
  final Stream<QuerySnapshot> snapshots = Firestore.instance.collection('chats')
                                                            .document(appointmentID)
                                                            .collection('messages')
                                                            .snapshots();

  StreamBuilder<QuerySnapshot> messagesStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) { return new Text('Error: ${snapshot.error}'); }

        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Column(children: <Widget>[
              new Flexible(
                child: ListView(
                  reverse: true,
                  padding: new EdgeInsets.all(6.0),
                ),
              ),
              new Divider(height: 1.0),
            ]);

          default:
            return new Column(children: <Widget>[
              new Flexible(
                child: ListView(
                  reverse: true,
                  padding: new EdgeInsets.all(6.0),
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                    String messageText = (document.data.containsKey("message")) ? document['message'] : "";
                    return new Text(messageText);
                    //(document.data.containsKey("message")) { return new Text(document['message']); }
                    },
                  ).toList(),
                ),
              ),
              new Divider(height: 1.0),
            ]);
        }
      }
    );
  }
}