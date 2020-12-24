import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(this.msg);
  final EMMessage msg;
  @override
  Widget build(BuildContext context) {
    bool isRecv = msg.direction == EMMessageDirection.RECEIVE;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      textDirection: isRecv ? TextDirection.ltr : TextDirection.rtl,
      children: [
        Container(
          height: sWidth(42),
          width: sWidth(42),
          margin: EdgeInsets.only(
            left: sWidth(isRecv ? 20 : 10),
            right: sWidth(!isRecv ? 20 : 10),
          ),
          child: _avatarWidget(),
        ),
        _messageWidget(isRecv),
        _messageStateWidget(),
      ],
    );
  }

  _avatarWidget() {
    return Image.asset(
      'images/contact_default_avatar.png',
    );
  }

  _messageWidget(bool isRecv) {
    EMMessageBody body = msg.body;
    return Container(
      constraints: BoxConstraints(
        maxWidth: sWidth(220),
      ),
      margin: EdgeInsets.only(
        top: sHeight(3),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(!isRecv ? 10 : 0),
          topRight: Radius.circular(isRecv ? 10 : 0),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: Color.fromRGBO(193, 227, 252, 1),
      ),
      child: ChatMessageBubble(body),
    );
  }

  _messageStateWidget() {
    return Container();
  }
}

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble(this.body);
  final EMMessageBody body;
  @override
  Widget build(BuildContext context) {
    Widget bubble;
    switch (body.type) {
      case EMMessageBodyType.TXT:
        bubble = _textBubble(body);
        break;
      case EMMessageBodyType.LOCATION:
        bubble = _locationBubble(body);
        break;
      case EMMessageBodyType.IMAGE:
        bubble = _imageBubble(body);
        break;
      case EMMessageBodyType.VOICE:
        bubble = _voiceBubble(body);
        break;
      case EMMessageBodyType.VIDEO:
        bubble = _videoBubble(body);
        break;
      case EMMessageBodyType.FILE:
        bubble = _fileBubble(body);
        break;
      case EMMessageBodyType.CMD:
      case EMMessageBodyType.CUSTOM:
        bubble = Container();
    }
    return bubble;
  }

  _textBubble(EMTextMessageBody body) {
    return Container(
      padding: EdgeInsets.only(
        left: sWidth(13),
        right: sWidth(13),
        top: sHeight(9),
        bottom: sHeight(9),
      ),
      child: Text(
        body.content,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Color.fromRGBO(51, 51, 51, 1),
          fontSize: sFontSize(17),
        ),
      ),
    );
  }

  _locationBubble(EMLocationMessageBody body) {}
  _imageBubble(EMImageMessageBody body) {}
  _voiceBubble(EMVoiceMessageBody body) {}
  _videoBubble(EMVideoMessageBody body) {}
  _fileBubble(EMFileMessageBody body) {}
}
