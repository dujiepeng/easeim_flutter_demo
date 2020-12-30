import 'package:easeim_flutter_demo/pages/chat/chat_input_bar.dart';
import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'chat_items/chat_item.dart';
import 'chat_more_view.dart';

enum KeyboardState {
  normal,
  input,
  emoji,
  more,
}

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
  List<ChatMoreViewItem> items;

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
  KeyboardState _keyboardState = KeyboardState.normal;

  /// 消息List
  List<EMMessage> _msgList = List();

  @override
  void initState() {
    super.initState();
    // 监听键盘弹起收回
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        _setStateAndMoreToListViewEnd();
      },
    );

    items = [
      ChatMoreViewItem(
          'images/chat_input_more_photo.png', '相册', _moreViewPhotoBtnOnTap),
      ChatMoreViewItem(
          'images/chat_input_more_camera.png', '相机', _moreCameraBtnOnTap),
      ChatMoreViewItem(
          'images/chat_input_more_call.png', '音视频', _moreCallBtnOnTap),
      ChatMoreViewItem(
          'images/chat_input_more_loc.png', '位置', _moreLocalBtnOnTap),
      ChatMoreViewItem(
          'images/chat_input_more_file.png', '文件', _moreFileBtnOnTap),
      ChatMoreViewItem(
          'images/chat_input_more_pin.png', '群组回执', _morePinBtnOnTap),
    ];

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
                            return _chatItemFromMessage(_msgList[index], index);
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
            ),
            _bottomWidget(),
          ],
        ),
      ),
    );
  }

  /// 返回消息item，需要有高度
  _chatItemFromMessage(EMMessage msg, int index) {
    _makeMessageAsRead(msg);
    bool needShowTime = false;
    if (_adjacentTime == 0 ||
        (msg.serverTime - _adjacentTime).abs() > _timeInterval ||
        index == 0) {
      needShowTime = true;
    }

    _adjacentTime = msg.serverTime;

    if (needShowTime) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: sHeight(10)),
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

  /// 重发消息
  void _resendMessage(EMMessage msg) {
    print('点击重发按钮');
  }

  /// 发送消息已读回执
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

  /// 输入框下部分View
  _bottomWidget() {
    if (_keyboardState == KeyboardState.more) return _moreWidget();
    if (_keyboardState == KeyboardState.emoji)
      return _faceWidget();
    else {
      return Container();
    }
  }

  /// 更多功能View
  _moreWidget() {
    return ChatMoreView(items);
  }

  /// 表情View
  _faceWidget() {
    return Container(
      color: Colors.blue,
      height: 100,
      width: 100,
    );
  }

  /// 下拉加载更多消息
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
        _setStateAndMoreToListViewEnd();
      } else {
        setState(() {});
      }
    }
  }

  /// 刷新View并滑动到最底部
  _setStateAndMoreToListViewEnd() {
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () {
      _scorllController.jumpTo(_scorllController.position.maxScrollExtent);
    });
  }

  _sendMessage(EMMessage msg) async {
    _msgList.add(msg);
    _setStateAndMoreToListViewEnd();
    EMClient.getInstance.chatManager.sendMessage(msg);
  }

  /// 发送文字消息
  _sendTextMessage(String txt) {
    EMMessage msg =
        EMMessage.createTxtSendMessage(username: widget.conv.id, content: txt);
    _sendMessage(msg);
  }

  /// 相册按钮被点击
  _moreViewPhotoBtnOnTap() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      EMMessage msg = EMMessage.createImageSendMessage(
          username: widget.conv.id, filePath: pickedFile.path);
      _sendMessage(msg);
    }
  }

  _moreCameraBtnOnTap() {
    print('_moreCameraBtnOnTap');
  }

  /// 音视频按钮被点击
  _moreCallBtnOnTap() async {
    try {
      await EMClient.getInstance.callManager
          .makeCall(EMCallType.Voice, widget.conv.id);
      Navigator.of(context).pushNamed('/voicecall');
    } on EMError catch (e) {
      print('call error ---${e.description}');
    } on Error catch (e) {
      print('flutter error -- $e');
    }
  }

  /// 位置按钮被点击
  _moreLocalBtnOnTap() {
    print('_moreLocalBtnOnTap');
  }

  /// 文件按钮被点击
  _moreFileBtnOnTap() {
    print('_moreFileBtnOnTap');
  }

  /// 大头针按钮被点击
  _morePinBtnOnTap() {
    print('_morePinBtnOnTap');
  }

  @override
  void voiceBtnDragInside() {
    print('录音按钮内部');
    _setStateAndMoreToListViewEnd();
  }

  @override
  void voiceBtnDragOutside() {
    print('录音按钮外部');
    _setStateAndMoreToListViewEnd();
  }

  @override
  void voiceBtnTouchDown() {
    print('录音按钮被按下');
    _setStateAndMoreToListViewEnd();
  }

  @override
  void voiceBtnTouchUpInside() {
    print('录音按钮被内部抬起');
    _setStateAndMoreToListViewEnd();
  }

  @override
  void voiceBtnTouchUpOutside() {
    print('录音按钮被外部抬起');
    _setStateAndMoreToListViewEnd();
  }

  @override
  void emojiBtnOnTap() {
    if (_keyboardState == KeyboardState.emoji) {
      _keyboardState = KeyboardState.input;
    } else {
      _keyboardState = KeyboardState.emoji;
    }
    _setStateAndMoreToListViewEnd();
  }

  @override
  void moreBtnOnTap() {
    if (_keyboardState == KeyboardState.more) {
      _keyboardState = KeyboardState.input;
    } else {
      _keyboardState = KeyboardState.more;
    }
    _setStateAndMoreToListViewEnd();
  }

  @override
  void recordOrTextBtnOnTap() {
    if (_keyboardState == KeyboardState.normal) {
      _keyboardState = KeyboardState.input;
    } else {
      _keyboardState = KeyboardState.normal;
    }
    _showRecord = !_showRecord;
    _setStateAndMoreToListViewEnd();
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
    _setStateAndMoreToListViewEnd();
  }

  @override
  onConversationsUpdate() {}
}
