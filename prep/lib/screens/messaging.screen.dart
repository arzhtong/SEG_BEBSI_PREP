import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:pointycastle/api.dart' as pc;
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import 'package:hex/hex.dart';

import '../utils/query.dart';

class _MockData {
  _MockData() {
    //iinitialise mock message list
    for (int i = 10; i > 0; i--) {
      bool isPatientMessage = (i % 2 == 0) ? true : false;
      messagesList.add(
        _MessageData(
          messageText: "Lorem Ipsum. Message $i",
          isPatient: isPatientMessage,
          datetime: DateTime.now().subtract(Duration(seconds: i * 60)),
          seenByStaff: isPatientMessage,
        ),
      );
    }
  }

  static List<_MessageData> messagesList;
}

class MessagingScreen extends StatefulWidget {
  @override
  State createState() => MessagingScreenState();
}

class MessagingScreenState extends State<MessagingScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _hasTyped = false;
  final ScrollController _scrollController = ScrollController();
  List<_MessageData> _messagesList = [];
  StreamSubscription<QuerySnapshot> messageStreamSubscription;
  bool _firstTimeLoading = true;

  @override
  void initState() {
    super.initState();
    print("InitState ran!");
    //Subscribe to Message stream
    /* FirebaseAuth.instance.signInAnonymously().catchError((error) {
        var errorCode = error.code;
        var errorMessage = error.message;
        print(
            "Firebase Auth anonymous sign-in error-> $errorCode : $errorMessage");
      }).then((user) { */

    //Load all initial messages.
    //TODO Remove the first forEach somehow...
    MessagingQueries().messageDocuments.then((querySnapshot) {
      querySnapshot.documents.forEach((documentSnapshot) {
        _loadMessageFromFirestore(documentSnapshot);
      });
    });

    messageStreamSubscription =
        MessagingQueries().messageSnapshots.listen((QuerySnapshot snapshot) {
      snapshot.documentChanges.forEach((DocumentChange change) {
        if (change.type == DocumentChangeType.added) {
          print("Document Addition Detected");
          DocumentSnapshot documentSnaphot = change.document;

          _loadMessageFromFirestore(documentSnaphot);
        }
      });
    });
    /* }); */
  }

  void _loadMessageFromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> message = document.data;

    if (!message['seenByPatient']) {
      MessagingQueries().setSeenByPatient(document.reference);
    }

    String decryptedMessage = decryptMessage(
        message['content'], message['datetime'].millisecondsSinceEpoch);

    _addMessageDataToInternalList(
        messageText: decryptedMessage,
        datetime: message['datetime'],
        isPatient: message['isPatient'],
        seenByStaff: message['seenByStaff']);

    _scrollMessageViewToBottom();
  }

  void _addMessageDataToInternalList(
      {String messageText,
      DateTime datetime,
      bool isPatient,
      bool seenByStaff}) {
    AnimationController animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _MessageData message = _MessageData(
        messageText: messageText,
        datetime: datetime,
        isPatient: isPatient,
        seenByStaff: seenByStaff,
        animController: animController);

    setState(() {
      _messagesList.insert(0, message);
    });
  }

  @override
  void dispose() {
    for (_MessageData message in _messagesList) {
      message.animController.dispose();
    }

    messageStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Name"), //TODO Add doctor name from datanase
      ),
      body: Column(children: <Widget>[
        Flexible(
          child: _buildMessageListView(),
        ),
        Divider(height: 1.0),
        Container(
          child: _buildTextComposer(),
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
        )
      ]),
    );
  }

  Widget _buildTextComposer() {
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
                  setState(() {
                    _hasTyped = userInputText.length > 0;
                  });
                },
                //onSubmitted: MessagingQueries().sendMessage,
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

  /* StreamBuilder<QuerySnapshot> _messagesStream(
                Stream<QuerySnapshot> snapshots) {
              return StreamBuilder<QuerySnapshot>(
                  stream: snapshots,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      //TODO (for production) print to console log.
                      return Text('Error: ${snapshot.error}');
                    }
          
                    switch (snapshot.connectionState) {
                      // waiting case may be removed when reading from cache is implemented
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
          
                      default:
                        List<Widget> children =
                            snapshot.data.documents.map((DocumentSnapshot document) {
                          Map<String, dynamic> message = document.data;
                          if (!message['seenByPatient']) {
                            MessagingQueries().setSeenByPatient(document.reference);
                          }
                          String decryptedMessage = decryptMessage(message['content'],
                              message['datetime'].millisecondsSinceEpoch);
          
                          var messageData = _MessageData(
                              messageText: decryptedMessage,
                              datetime: message['datetime'],
                              isPatient: message['isPatient'],
                              seenByStaff: message['seenByStaff']);
          
                          return _MessageListItem(messageData);
                        }).toList();
          
                        return _messageListView(children);
                    }
                  });
            } */

  void _scrollMessageViewToBottom() => _scrollController.animateTo(0.0,
      curve: Curves.ease, duration: const Duration(milliseconds: 300));

  Widget _buildMessageListView() {
    if (_messagesList.length == 0) {
      return CircularProgressIndicator();
    } else {
      return ListView.builder(
        reverse: true,
        itemBuilder: (_, int index) => _MessageListItem(_messagesList[index]),
        itemCount: _messagesList.length,
        controller: _scrollController,
      );
    }
  }

  pc.PaddedBlockCipher getCipher(
      bool mode, Uint8List iv, int millisSinceEpoch) {
    //TODO: remove appointmentCode and read from file when merging with develop
    //TODO: format encryption/decryption methods into new file
    //TODO: comment code
    const appointmentCode = "2vqqyqcc7";
    String millisStr = millisSinceEpoch.toString();
    String keyToEncode =
        appointmentCode + millisStr.substring(millisStr.length - 7);

    String keyEncoded = HEX.encode(utf8.encode(keyToEncode));
    List<int> keyEncodedList = utf8.encode(keyEncoded);

    pc.Mac mac = new pc.Mac("SHA-512/HMAC");
    mac.init(pc.KeyParameter(keyEncodedList));
    String keyHash = HEX.encode(mac.process(Uint8List(0))).substring(0, 32);
    Uint8List keyHashList = utf8.encode(keyHash);

    pc.PaddedBlockCipher cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESFastEngine()),
    );

    cipher.init(
      mode ? true : false,
      pc.PaddedBlockCipherParameters<pc.CipherParameters, pc.CipherParameters>(
        pc.ParametersWithIV<pc.KeyParameter>(pc.KeyParameter(keyHashList), iv),
        null,
      ),
    );
    return cipher;
  }

  String encryptMessage(String messageText, int millisSinceEpoch) {
    Random rand = Random.secure();
    int ivArrayLength = 16;
    Uint8List iv = Uint8List(ivArrayLength);
    for (int i = 0; i < ivArrayLength; ++i) {
      iv[i] = rand.nextInt(255);
    }

    String encodedIV = HEX.encode(iv);
    pc.PaddedBlockCipher cipher = getCipher(true, iv, millisSinceEpoch);

    String encodedMessage =
        HEX.encode(cipher.process(utf8.encode(messageText)));
    String encodedText = encodedIV + encodedMessage;
    return encodedText;
  }

  String decryptMessage(String hex, int millisSinceEpoch) {
    String encodedIV = hex.substring(0, 32);
    Uint8List iv = HEX.decode(encodedIV);
    pc.PaddedBlockCipher cipher = getCipher(false, iv, millisSinceEpoch);

    String encodedMessage = hex.substring(32);
    String decodedMessage =
        utf8.decode(cipher.process(HEX.decode(encodedMessage)));
    return decodedMessage;
  }

  void _sendMessage(String messageText) {
    if (_hasTyped) {
      setState(() {
        _hasTyped = false;
      });

      DateTime now = DateTime.now();

      String encryptedMessage =
          encryptMessage(messageText, now.millisecondsSinceEpoch);

      MessagingQueries().sendMessage(encryptedMessage, now);
      _textController.clear();
    }
  }
}

//Data class which hold information of a particular message
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
