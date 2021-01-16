import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum ChatInputBarType {
  // 无焦点，显示输入
  normal,
  // 有焦点，显示输入
  input,
  // 无焦点，显示表情
  emoji,
  // 无焦点，显示更多
  more,
}

class ChatInputBar extends StatefulWidget {
  /// '文字输入'样式
  ChatInputBar({
    @required this.listener,
    this.barType = ChatInputBarType.normal,
  });

  final ChatInputBarType barType;
  final ChatInputBarListener listener;
  @override
  State<StatefulWidget> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  /// 焦点管理
  FocusNode _inputFocusNode = FocusNode();

  bool _showVoiceBtn = false;
  bool _voiceBtnSelected = false;
  bool _voiceMoveIn = true;

  /// 输入框Controller
  TextEditingController _textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputFocusNode.addListener(() {
      // 获取焦点
      if (_inputFocusNode.hasFocus) {
        if (widget.listener != null) {
          widget.listener.textFieldOnTap();
        }
      }
    });
  }

  void dispose() {
    _textController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.barType == ChatInputBarType.input) {
      FocusScope.of(context).requestFocus(_inputFocusNode);
    } else {
      _inputFocusNode.unfocus();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // 语音按钮
        Container(
          height: sHeight(48),
          padding: EdgeInsets.only(
            bottom: sHeight(10),
            top: sHeight(10),
            left: sWidth(16),
            right: sWidth(6),
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (widget.listener != null)
                  widget.listener.recordOrTextBtnOnTap(isRecord: _showVoiceBtn);
                setState(() {
                  _showVoiceBtn = !_showVoiceBtn;
                });
              },
              child: Image.asset(
                _showVoiceBtn
                    ? 'images/chat_input_bar_voice_hidden.png'
                    : 'images/chat_input_bar_voice_show.png',
              ),
            ),
          ),
        ),
        // 语音，输入框
        Expanded(
          child: Container(
            constraints: BoxConstraints(
              minHeight: sHeight(32),
            ),
            margin: EdgeInsets.only(
              top: sHeight(6),
              bottom: sHeight(8),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: _showVoiceBtn && _voiceBtnSelected
                  ? Color.fromRGBO(198, 198, 198, 1)
                  : Color.fromRGBO(245, 245, 245, 1),
            ),
            child: _showVoiceBtn ? _recordButton() : _inputText(),
          ),
        ),
        // 表情按钮
        Container(
          height: sHeight(48),
          padding: EdgeInsets.only(
            bottom: sHeight(10),
            top: sHeight(10),
            left: sWidth(6),
            right: 0,
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () => _faceBtnOnTap(),
              child: Image.asset(
                'images/chat_input_bar_emoji.png',
              ),
            ),
          ),
        ),
        // 更多按钮
        Container(
          height: sHeight(48),
          padding: EdgeInsets.only(
            bottom: sHeight(10),
            top: sHeight(10),
            left: sWidth(6),
            right: sWidth(16),
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () => _moreBtnOnTap(),
              child: Image.asset(
                widget.barType == ChatInputBarType.more
                    ? 'images/chat_input_bar_more_close.png'
                    : 'images/chat_input_bar_more_show.png',
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 用于计算点击位置
  GlobalKey _gestureKey = GlobalKey();

  /// 录音按钮
  Widget _recordButton() {
    return Listener(
      behavior: HitTestBehavior.opaque,
      child: Container(
        key: _gestureKey,
        margin: EdgeInsets.only(
          top: sHeight(8),
          bottom: sHeight(6),
        ),
        child: Text(
          _voiceBtnSelected
              ? _voiceMoveIn
                  ? '松开发送'
                  : '松开取消'
              : '按住 说话',
          style: TextStyle(
            fontSize: sFontSize(14),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
      onPointerDown: (PointerDownEvent event) {
        _touchDown();
      },
      onPointerMove: (PointerMoveEvent event) {
        RenderBox renderBox = _gestureKey.currentContext.findRenderObject();
        Offset offset = event.localPosition;
        _voiceDragUp(renderBox.size, offset);
      },
      onPointerUp: (PointerUpEvent event) {
        RenderBox renderBox = _gestureKey.currentContext.findRenderObject();
        Offset offset = event.localPosition;
        _voiceTouchUp(renderBox.size, offset);
      },
    );
  }

  /// 输入框
  Widget _inputText() {
    return TextFormField(
      focusNode: _inputFocusNode,
      textInputAction: TextInputAction.send,
      onEditingComplete: () {},
      style: TextStyle(
        fontSize: sFontSize(14),
      ),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      controller: _textController,
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(
          sWidth(16),
          sHeight(8),
          sWidth(16),
          sHeight(6),
        ),
        hintText: '请输入消息内容',
        hintStyle: TextStyle(
          fontSize: sFontSize(14),
          color: Colors.grey,
        ),
      ),
      onFieldSubmitted: (str) => _sendBtnDidClicked(str),
    );
  }

  _voiceDragUp(Size size, Offset offset) {
    bool outside = false;
    if (offset.dx < 0 || offset.dy < 0) {
      outside = true;
    } else if (size.width - offset.dx < 0 || size.height - offset.dy < 0) {
      outside = true;
    }
    if (!outside) {
      _dragInside();
    } else {
      _dragOutside();
    }
  }

  _voiceTouchUp(Size size, Offset offset) {
    bool outside = false;
    if (offset.dx < 0 || offset.dy < 0) {
      outside = true;
    } else if (size.width - offset.dx < 0 || size.height - offset.dy < 0) {
      outside = true;
    }
    if (!outside) {
      _touchUpInside();
    } else {
      _touchUpOutside();
    }

    setState(() {
      _voiceBtnSelected = false;
    });
  }

  _faceBtnOnTap() {
    _showVoiceBtn = false;
    _voiceBtnSelected = false;
    FocusScope.of(context).requestFocus(FocusNode());
    if (widget.listener != null) {
      widget.listener.emojiBtnOnTap();
    }
  }

  _moreBtnOnTap() {
    _showVoiceBtn = false;
    _voiceBtnSelected = false;
    if (widget.listener != null) {
      widget.listener.moreBtnOnTap();
    }
  }

  _touchDown() {
    if (widget.listener != null) {
      widget.listener.voiceBtnTouchDown();
    }
    setState(() {
      _voiceBtnSelected = true;
      _voiceMoveIn = true;
    });
  }

  _touchUpInside() {
    if (widget.listener != null) {
      widget.listener.voiceBtnTouchUpInside();
    }
  }

  _touchUpOutside() {
    if (widget.listener != null) {
      widget.listener.voiceBtnTouchUpOutside();
    }
  }

  _dragInside() {
    setState(() => _voiceMoveIn = true);
    if (widget.listener != null) {
      widget.listener.voiceBtnDragInside();
    }
  }

  _dragOutside() {
    setState(() => _voiceMoveIn = false);
    if (widget.listener != null) {
      widget.listener.voiceBtnDragOutside();
    }
  }

  _sendBtnDidClicked(String txt) {
    if (widget.listener != null && txt.length > 0) {
      _textController.text = '';
      widget.listener.sendBtnOnTap(txt);
    }
  }
}

abstract class ChatInputBarListener {
  /// 录音/文字按钮被点击
  void recordOrTextBtnOnTap({bool isRecord = false});

  /// 录音按钮按下
  void voiceBtnTouchDown();

  /// 录音按钮在内部弹起
  void voiceBtnTouchUpInside();

  /// 录音按钮在外部弹起
  void voiceBtnTouchUpOutside();

  /// 移动到录音按钮内部
  void voiceBtnDragInside();

  /// 移动到录音按钮外部
  void voiceBtnDragOutside();

  /// '表情'按钮被点击
  void emojiBtnOnTap();

  /// '更多'按钮被点击
  void moreBtnOnTap();

  /// '输入框'按钮被点击
  void textFieldOnTap();

  /// 发送按钮被点击
  void sendBtnOnTap(String str);
}
