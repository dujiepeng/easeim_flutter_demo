import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    @required String chatId,
    EMConversationType type = EMConversationType.Chat,
  })  : chatId = chatId,
        convType = type;

  final String chatId;
  final EMConversationType convType;

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  EMConversation _conv;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('_conv.id --- $_conv.id');
    return Container();
  }
}
