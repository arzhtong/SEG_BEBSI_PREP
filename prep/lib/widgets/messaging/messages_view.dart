import 'package:flutter/material.dart';

import 'package:prep/utils/misc_functions.dart';

class MessagesView extends StatefulWidget {
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

class _MessagesViewState extends State<MessagesView>
    with TickerProviderStateMixin {
  List<_MessageData> _messagesList = [];

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
  }

  void dispose() {
    for (_MessageData message in _messagesList) {
      message.animController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: ListView.builder(
          key: Key('messagesView'),
          padding: EdgeInsets.only(top: 8.0),
          reverse: true,
          itemBuilder: (_, int index) {
            String currentDate = dateFormatter(_messagesList[index].datetime);
            String nextDate = dateFormatter((index == _messagesList.length - 1)
                ? null
                : _messagesList[index + 1].datetime);

            return _MessageListItem(
              message: _messagesList[index],
              showDate: (currentDate == nextDate) ? false : true,
            );
          },
          itemCount: _messagesList.length,
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
  final bool showDate;

  _MessageListItem({@required this.message, @required this.showDate})
      : rowAlignment = (message.isPatient)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        messageBackgroundColor =
            (message.isPatient) ? Colors.blue[200] : Colors.grey[300];

  final MainAxisAlignment rowAlignment;
  final Color messageBackgroundColor;

  Widget _getStatusLine(BuildContext context) {
    var statuslineTimestamp = Text(
      message.datetime.toString().substring(10, 16),
      style: TextStyle(fontSize: 12.0),
    );

    return Row(
      mainAxisAlignment: rowAlignment,
      children: <Widget>[
        statuslineTimestamp,
      ],
    );
  }

  Widget _getDateLine(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        dateFormatter(message.datetime),
        style: TextStyle(fontSize: 12.0),
      ),
      Divider(),
    ]);
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
          showDate ? _getDateLine(context) : Container(),
          _getStatusLine(context),
          _getMessageBody(context),
          Divider(),
        ],
      ),
    );
  }
}
