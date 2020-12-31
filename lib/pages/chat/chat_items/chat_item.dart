import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ChatItem extends StatefulWidget {
  const ChatItem(this.msg, this.errorBtnOnTap, {this.avatarOnTap});
  final EMMessage msg;

  /// 重发按钮点击
  final Function(EMMessage msg) errorBtnOnTap;

  /// 头像按钮点击
  final Function(String eid) avatarOnTap;

  @override
  State<StatefulWidget> createState() => ChatItemState();
}

class ChatItemState extends State<ChatItem> implements EMMessageStatusListener {
  @override
  Widget build(BuildContext context) {
    widget.msg.setMessageListener(this);
    bool isRecv = widget.msg.direction == EMMessageDirection.RECEIVE;
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
        _messageStateWidget(isRecv),
      ],
    );
  }

  _avatarWidget() {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (widget.avatarOnTap != null) {
          widget.avatarOnTap(widget.msg.from);
        }
      },
      child: Image.asset(
        'images/contact_default_avatar.png',
      ),
    );
  }

  _messageWidget(bool isRecv) {
    EMMessageBody body = widget.msg.body;
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
        color: isRecv ? Colors.white : Color.fromRGBO(193, 227, 252, 1),
      ),
      child: ChatMessageBubble(body),
    );
  }

  /// 消息状态，
  /// 单聊发送方：消息状态和对方是否已读；
  ///
  /// 群聊发送方：消息状态；
  _messageStateWidget(bool isRecv) {
    // 发出的消息
    if (!isRecv) {
      // 对方已读
      if (widget.msg.hasReadAck) {
        return Container(
          margin: EdgeInsets.only(
            left: sWidth(5),
            right: sWidth(5),
            bottom: sWidth(10),
            top: sWidth(10),
          ),
          child: Center(
            child: Text(
              '已读',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        );
      } else {
        if (widget.msg.status == EMMessageStatus.PROGRESS) {
          return Padding(
            padding: EdgeInsets.all(sWidth(10)),
            child: SizedBox(
              width: sWidth(13),
              height: sWidth(13),
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
          );
        } else if (widget.msg.status == EMMessageStatus.FAIL) {
          return IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.error,
                color: Colors.red,
              ),
              onPressed: () {
                if (widget.errorBtnOnTap != null) {
                  widget.errorBtnOnTap(widget.msg);
                }
              });
        }
      }
    }
    return Container();
  }

  @override
  void onDeliveryAck() {}

  @override
  void onError(EMError error) {
    setState(() {});
    print('发送失败');
  }

  @override
  void onProgress(int progress) {}

  @override
  void onReadAck() {
    setState(() {});
    print('收到已读回调');
  }

  @override
  void onStatusChanged() {}

  @override
  void onSuccess() {
    setState(() {});
    print('发送成功');
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

  _locationBubble(EMLocationMessageBody body) {
    return Container(
      child: Stack(
        children: [],
      ),
    );
  }

  _imageBubble(EMImageMessageBody body) {
    return Container(
      child: Stack(
        children: [],
      ),
    );
  }

  _voiceBubble(EMVoiceMessageBody body) {
    return Container(
      child: Stack(
        children: [],
      ),
    );
  }

  _videoBubble(EMVideoMessageBody body) {
    return Container(
      child: Stack(
        children: [],
      ),
    );
  }

  _fileBubble(EMFileMessageBody body) {
    return Container(
      child: Stack(
        children: [],
      ),
    );
  }
}
