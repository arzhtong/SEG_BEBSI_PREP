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

import 'package:hex/hex.dart';

import '../utils/query.dart';

class Messaging extends StatefulWidget {
  @override
  State createState() => MessagingScreen();
}

class MessagingScreen extends State<Messaging> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _hasTyped = false;
  final ScrollController _scrollController = ScrollController();
  //List<_Message> _messagesList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Name"), //TODO Add doctor name from datanase
      ),
      body: Column(children: <Widget>[
        Flexible(child: _messagesStream(MessagingQueries().messagesSnapshots)),
        Divider(height: 1.0),
        Container(
          child: _buildTextComposer(),
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
        )
      ]),
    );
  }

  void _scrollMessageViewToBottom() => _scrollController.animateTo(0.0,
      curve: Curves.ease, duration: const Duration(milliseconds: 300));

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

  StreamBuilder<QuerySnapshot> _messagesStream(
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
                return _Message(decryptedMessage, message['datetime'],
                    message['isPatient'], message['seenByStaff']);
              }).toList();

              return _messageListView(children);
          }
        });
  }

  ListView _messageListView(List<Widget> childrenIn) {
    var retVal = ListView(
      reverse: true,
      children: childrenIn,
      controller: _scrollController,
    );
    _scrollMessageViewToBottom();
    return retVal;
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

class _Message extends StatelessWidget {
  _Message(this.messageText, this.datetime, this.isPatient, this.seenByStaff)
      : rowAlignment =
            (isPatient) ? MainAxisAlignment.end : MainAxisAlignment.start,
        messageBackgroundColor = (isPatient)
            ? Colors.greenAccent
            : Colors.lightBlueAccent, //TODO use Theme colors
        statuslineTimestamp = Text(
          datetime.toString().substring(10, 16),
          style: TextStyle(fontSize: 12.0),
        );

  final String messageText;
  final DateTime datetime;

  final bool seenByStaff;
  final bool isPatient;
  final MainAxisAlignment rowAlignment;
  final Color messageBackgroundColor;
  final bool shouldWrap = true; // not yet used...
  final Widget statuslineTimestamp;

  Widget _getStatusLine(BuildContext context) {
    return Row(
      mainAxisAlignment: rowAlignment,
      children: (isPatient)
          ? <Widget>[
              //Time sent
              statuslineTimestamp,
              //Read Receipt
              Icon(((seenByStaff) ? Icons.done_all : Icons.done),
                  color: (seenByStaff)
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
                  messageText,
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
