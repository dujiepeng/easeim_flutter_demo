import 'package:easeim_flutter_demo/pages/conversations/conversation_item.dart';
import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class ConversationPage extends StatefulWidget with ChangeNotifier {
  num totalUnreadCount = 0;

  updateCount(num count) {
    totalUnreadCount = count;
    notifyListeners();
  }

  @override
  State<StatefulWidget> createState() => ConversationPageState();
}

class ConversationPageState extends State<ConversationPage>
    implements EMChatManagerListener {
  List<EMConversation> _conversationsList = List();

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  @override
  void initState() {
    super.initState();
    // 添加环信回调监听
    EMClient.getInstance.chatManager.addListener(this);
  }

  void dispose() {
    // 移除环信回调监听
    EMClient.getInstance.chatManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Title(
          color: Colors.white,
          child: Text(
            '会话',
          ),
        ),
      ),
      body: SmartRefresher(
        header: WaterDropHeader(
          completeDuration: Duration(milliseconds: 1000),
          complete: Text(
            '刷新完成',
            style: TextStyle(color: Colors.grey),
          ),
          failed: Text('刷新失败'),
        ),
        enablePullDown: true,
        onRefresh: () => _reLoadAllConversations(),
        controller: _refreshController,
        child: ListView.separated(
          itemBuilder: (_, int index) {
            // 数据data
            return conversationWidgetForIndex(index);
            //Text('testNum --- $testNum');
          },
          separatorBuilder: (_, int index) {
            // 间隔线
            return Container(
              margin: EdgeInsets.only(left: sWidth(78)),
              color: Color.fromRGBO(244, 244, 244, 1),
              height: sHeight(1),
            );
          },
          itemCount: _conversationsList.length,
        ),
      ),
    );
  }

  /// 更新会话列表
  void _reLoadAllConversations() async {
    try {
      List<EMConversation> list =
          await EMClient.getInstance.chatManager.loadAllConversations();
      _conversationsList.clear();
      _conversationsList.addAll(list);
      _refreshController.refreshCompleted();
      num count = 0;
      for (var conv in _conversationsList) {
        count += conv.unreadCount;
      }
      widget.updateCount(count);
    } on Error {
      _refreshController.refreshFailed();
    } finally {
      setState(() {});
    }
  }

  /// 获取会话列表widget
  Widget conversationWidgetForIndex(int index) {
    return slidableItem(
      child: ConversationItem(
        conv: _conversationsList[index],
        onTap: () => {_conversationItemOnPress(index)},
      ),
      // 侧滑事件，有必要可以加上置顶之类的
      actions: [slidableDeleteAction(onTap: () => _deleteConversation(index))],
    );
  }

  /// 侧滑删除按钮点击
  _deleteConversation(int index) async {
    try {
      await EMClient.getInstance.chatManager
          .deleteConversation(_conversationsList[index].id);
      _conversationsList.removeAt(index);
    } on Error {} finally {
      setState(() {});
    }
  }

  /// 会话被点击
  _conversationItemOnPress(int index) {
    EMConversation conv = _conversationsList[index];
    Navigator.of(context).pushNamed('/chat', arguments: conv).then((value) {
      // 返回时刷新页面
      _reLoadAllConversations();
    });
  }

  @override
  onCmdMessagesReceived(List<EMMessage> messages) {}

  @override
  onMessagesDelivered(List<EMMessage> messages) {}

  @override
  onMessagesRead(List<EMMessage> messages) {
    bool needReload = false;
    for (var msg in messages) {
      if (msg.to == EMClient.getInstance.currentUsername) {
        needReload = true;
        break;
      }
    }
    if (needReload) {
      _reLoadAllConversations();
    }
  }

  @override
  onMessagesRecalled(List<EMMessage> messages) {}

  @override
  onMessagesReceived(List<EMMessage> messages) {
    _reLoadAllConversations();
  }
}
