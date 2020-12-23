import 'package:easeim_flutter_demo/pages/chat/chat_input_bar.dart';
import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  /// 页面所属会话
  EMConversation _conv;

  /// 下拉刷新Controller
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ChatInputBar _inputBar;

  /// 消息List
  List<EMMessage> _msgList;

  @override
  void initState() {
    super.initState();
    _msgList = List();
  }

  @override
  Widget build(BuildContext context) {
    _inputBar = ChatInputBar();

    _conv = ModalRoute.of(context).settings.arguments as EMConversation;
    // 设置所有消息已读
    _conv.markAllMessagesAsRead();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          child: Text(_conv.id),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // 消息内容
            Flexible(
              child: Container(
                color: Color.fromRGBO(242, 242, 242, 1.0),
                child: SmartRefresher(
                  enablePullDown: true,
                  onRefresh: () => _loadMoreMessages(),
                  controller: _refreshController,
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      return Container();
                    },
                    separatorBuilder: (_, index) {
                      return Container();
                    },
                    itemCount: _msgList.length,
                  ),
                ),
              ),
            ),
            // 间隔线
            Divider(height: 1.0),
            // 输入框
            Container(
              constraints: BoxConstraints(
                maxHeight: sHeight(90),
                minHeight: sHeight(44),
              ),
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _inputBar,
            )
          ],
        ),
      ),
    );
  }

  _loadMoreMessages() {
    _conv.loadMessagesWithStartId(_msgList.first.msgId, 20);
  }
}
