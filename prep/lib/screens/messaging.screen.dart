import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:pointycastle/api.dart';
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
  //List<_Message> _messagesList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
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
                icon: Icon(Icons.send),
                onPressed: () => _sendMessage(_textController.text),
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
              return _messageListView(null);

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
    bool isReverse = true;

    return (childrenIn == null)
        ? ListView(reverse: isReverse)
        : ListView(reverse: isReverse, children: childrenIn);
  }

  PaddedBlockCipher getCipher(bool mode, Uint8List iv, int millisSinceEpoch) {
    //TODO: remove appointmentCode and read from file when merging with develop
    //TODO: format encryption/decryption methods into new file
    //TODO: comment code
    const appointmentCode = "2vqqyqcc7";
    String keyEncoded = HEX
        .encode(utf8.encode(appointmentCode + millisSinceEpoch.toString()))
        .substring(0, 32);
    List<int> keyEncodedList = utf8.encode(keyEncoded);

    Mac mac = new Mac("SHA-512/HMAC");
    mac.init(KeyParameter(keyEncodedList));
    String keyHash = HEX.encode(mac.process(Uint8List(0))).substring(0, 32);
    Uint8List keyHashList = utf8.encode(keyHash);

    PaddedBlockCipher cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESFastEngine()),
    );

    cipher.init(
      mode ? true : false,
      PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
        ParametersWithIV<KeyParameter>(KeyParameter(keyHashList), iv),
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
    PaddedBlockCipher cipher = getCipher(true, iv, millisSinceEpoch);

    String encodedMessage =
        HEX.encode(cipher.process(utf8.encode(messageText)));
    String encodedText = encodedIV + encodedMessage;
    return encodedText;
  }

  String decryptMessage(String hex, int millisSinceEpoch) {
    String encodedIV = hex.substring(0, 32);
    Uint8List iv = HEX.decode(encodedIV);
    PaddedBlockCipher cipher = getCipher(false, iv, millisSinceEpoch);

    String encodedMessage = hex.substring(32);
    String decodedMessage =
        utf8.decode(cipher.process(HEX.decode(encodedMessage)));
    return decodedMessage;
  }

  void _sendMessage(String messageText) {
    if (_hasTyped) {
      DateTime now = DateTime.now();
      String encryptedMessage =
          encryptMessage(messageText, now.millisecondsSinceEpoch);
      MessagingQueries().sendMessage(encryptedMessage, now);
      _textController.clear();
    }
  }
}

class _Message extends StatelessWidget {
  _Message(this.messageText, this.datetime, this.isPatient, this.seenByStaff);

  final String messageText;
  final DateTime datetime;
  final bool isPatient;
  final bool seenByStaff;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: (isPatient) ? Colors.greenAccent : Colors.white),
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        child: Stack(children: <Widget>[
          Text(
            messageText,
            style: TextStyle(fontSize: 16.0),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Row(children: <Widget>[
              Text(
                datetime.toString().substring(10, 16),
                style: TextStyle(fontSize: 12.0),
              ),
              SizedBox(width: 4.0),
              Icon(((seenByStaff) ? Icons.done_all : Icons.done),
                  color: (seenByStaff) ? Colors.lightBlue : Colors.blueGrey,
                  size: 16.0),
            ]),
          )
        ]));
  }
}
