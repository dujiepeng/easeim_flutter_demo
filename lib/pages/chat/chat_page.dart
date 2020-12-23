import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ChatPage extends StatefulWidget {
  ChatPage({@required this.conv});

  final EMConversation conv;

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('_conv.id --- $widget.conv.id');
    return Container();
  }
}
