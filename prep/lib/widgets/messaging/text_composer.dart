import 'package:flutter/material.dart';

import 'package:prep/utils/message_crypto.dart';
import 'package:prep/utils/query.dart';

class TextComposer extends StatefulWidget {
  @override
  State createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
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
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: IconTheme(
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
                        autocorrect: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _textController,
                        onChanged: (userInputText) {
                          setState(() => _hasTyped = userInputText.length > 0);
                        },
                        decoration: InputDecoration.collapsed(
                            hintText: "Type a message"),
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
      ),
    );
  }
}
