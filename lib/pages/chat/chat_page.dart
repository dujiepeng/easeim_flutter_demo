import 'package:easeim_flutter_demo/pages/chat/chat_input_bar.dart';
import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'chat_items/chat_item.dart';

class ChatPage extends StatefulWidget {
  ChatPage(EMConversation conversation) : conv = conversation;
  final EMConversation conv;
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage>
    implements ChatInputBarListener, EMChatManagerListener {
  final _scorllController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  /// 时间显示间隔为1分钟
  final int _timeInterval = 60 * 1000;

  ChatInputBar _inputBar;

  bool _showMore = false;
  bool _showRecord = false;
  bool _firstLoad = true;
  bool _showEmoji = false;
  int _adjacentTime = 0;

  /// 消息List
  List<EMMessage> _msgList = List();

  @override
  void initState() {
    super.initState();
    // 监听键盘弹起收回
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        _resetStateAndMoreToListViewEnd();
      },
    );

    // 添加环信回调监听
    EMClient.getInstance.chatManager.addListener(this);
    // 设置所有消息已读
    widget.conv.markAllMessagesAsRead();
  }

  void dispose() {
    // 移除环信回调监听
    EMClient.getInstance.chatManager.removeListener(this);
    _scorllController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _inputBar = ChatInputBar(
      listener: this,
      moreModel: _showMore,
      voiceModel: _showRecord,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          child: Text(widget.conv.id),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // 消息内容
            Flexible(
              child: Container(
                // padding: EdgeInsets.only(bottom: 20),
                color: Color.fromRGBO(242, 242, 242, 1.0),
                child: SmartRefresher(
                  enablePullDown: true,
                  onRefresh: () => _loadMessages(moveBottom: _firstLoad),
                  controller: _refreshController,
                  child: CustomScrollView(
                    controller: _scorllController,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return _chatItemFromMessage(_msgList[index]);
                          },
                          childCount: _msgList.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 间隔线
            Divider(height: 1.0),
            // 输入框
            Container(
              // 限制输入框高度
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

  /// 返回消息item，需要有高度
  _chatItemFromMessage(EMMessage msg) {
    _makeMessageAsRead(msg);
    bool needShowTime = false;
    if (_adjacentTime == 0 || msg.serverTime - _adjacentTime > _timeInterval) {
      needShowTime = true;
    }

    _adjacentTime = msg.serverTime;

    if (needShowTime) {
      return Column(
        children: [
          Container(
            child: Text(
              timeStrByMs(msg.serverTime, showTime: true),
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minWidth: double.infinity,
            ),
            child: ChatItem(msg, _resendMessage),
            margin: EdgeInsets.only(
              top: sHeight(20),
              bottom: sHeight(20),
            ),
          )
        ],
      );
    } else {
      return Container(
        child: ChatItem(msg, _resendMessage),
        margin: EdgeInsets.only(
          top: sHeight(20),
          bottom: sHeight(20),
        ),
      );
    }
  }

  void _resendMessage(EMMessage msg) {
    print('点击重发按钮');
  }

  _makeMessageAsRead(EMMessage msg) async {
    if (msg.chatType == EMMessageChatType.Chat &&
        msg.direction == EMMessageDirection.RECEIVE) {
      if (msg.hasReadAck == false) {
        try {
          await EMClient.getInstance.chatManager.sendMessageReadAck(msg);
        } on EMError {}
      }
      if (msg.hasRead == false) {
        try {
          await widget.conv.markMessageAsRead(msg.msgId);
        } on EMError catch (e) {
          print(e);
        }
      }
    }
  }

  _loadMessages({int count = 20, bool moveBottom = true}) async {
    _firstLoad = false;
    if (_refreshController.isRefresh == false) {
      return;
    }
    try {
      List<EMMessage> msgs = await widget.conv.loadMessagesWithStartId(
          _msgList.length > 0 ? _msgList.first.msgId : '', count);
      _msgList.insertAll(0, msgs);
    } on EMError catch (e) {
      print('load more message emErr -- ${e.description}');
    } on Error catch (e) {
      print('load more message err -- $e');
    } finally {
      _refreshController.refreshCompleted();

      if (moveBottom) {
        _resetStateAndMoreToListViewEnd();
      } else {
        setState(() {});
      }
    }
  }

  _resetStateAndMoreToListViewEnd() {
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () {
      _scorllController.jumpTo(_scorllController.position.maxScrollExtent);
    });
  }

  _sendTextMessage(String txt) async {
    EMMessage msg =
        EMMessage.createTxtSendMessage(username: widget.conv.id, content: txt);
    _msgList.add(msg);
    _resetStateAndMoreToListViewEnd();
    EMClient.getInstance.chatManager.sendMessage(msg);
  }

  @override
  void voiceBtnDragInside() {
    print('录音按钮内部');
  }

  @override
  void voiceBtnDragOutside() {
    print('录音按钮外部');
  }

  @override
  void voiceBtnTouchDown() {
    print('录音按钮被按下');
  }

  @override
  void voiceBtnTouchUpInside() {
    print('录音按钮被内部抬起');
  }

  @override
  void voiceBtnTouchUpOutside() {
    print('录音按钮被外部抬起');
  }

  @override
  void emojiBtnOnTap() {
    print('表情按钮被按下');
  }

  @override
  void moreBtnOnTap() {
    setState(() {
      _showMore = !_showMore;
    });
  }

  @override
  void recordOrTextBtnOnTap() {
    setState(() {
      _showRecord = !_showRecord;
    });
  }

  @override
  void sendBtnOnTap(String str) => _sendTextMessage(str);

  @override
  onCmdMessagesReceived(List<EMMessage> messages) {}

  @override
  onMessagesDelivered(List<EMMessage> messages) {}

  @override
  onMessagesRead(List<EMMessage> messages) {}

  @override
  onMessagesRecalled(List<EMMessage> messages) {}

  @override
  onMessagesReceived(List<EMMessage> messages) {
    for (var msg in messages) {
      if (msg.conversationId == widget.conv.id) {
        _msgList.add(msg);
      }
    }
    _resetStateAndMoreToListViewEnd();
  }

  @override
  onConversationsUpdate() {}
}
