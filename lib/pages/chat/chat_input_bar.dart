import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  /// '文字输入'样式
  ChatInputBar.inputType({
    @required this.listener,
    this.moreModel = false,
  }) : voiceModel = false;

  /// '更多'样式
  ChatInputBar.moreType({
    @required this.listener,
    this.voiceModel = false,
    this.moreModel = true,
  });

  ChatInputBar({
    @required this.listener,
    this.voiceModel = false,
    this.moreModel = false,
  });

  final ChatInputBarListener listener;

  /// 输入框Controller
  final TextEditingController _textController = new TextEditingController();

  final bool voiceModel;
  final bool moreModel;

  @override
  Widget build(BuildContext context) {
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
                if (listener != null) listener.recordOrTextBtnOnTap();
              },
              child: Image.asset(
                voiceModel
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
              color: Color.fromRGBO(245, 245, 245, 1),
            ),
            child: voiceModel ? _recordButton() : _inputText(),
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
                moreModel
                    ? 'images/chat_input_bar_more_close.png'
                    : 'images/chat_input_bar_more_show.png',
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 录音按钮
  Widget _recordButton() {
    GlobalKey gestureKey = GlobalKey();
    return GestureDetector(
      key: gestureKey,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(
          top: sHeight(8),
          bottom: sHeight(6),
        ),
        child: Text(
          '按住 说话',
          style: TextStyle(
            fontSize: sFontSize(14),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
      onTapDown: (TapDownDetails details) => _touchDown(),
      onLongPressEnd: (LongPressEndDetails detail) {
        RenderBox renderBox = gestureKey.currentContext.findRenderObject();
        Offset offset = detail.localPosition;
        _voiceTouchUp(renderBox.size, offset);
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails detail) {
        RenderBox renderBox = gestureKey.currentContext.findRenderObject();
        Offset offset = detail.localPosition;
        _voiceDragUp(renderBox.size, offset);
      },
    );
  }

  /// 输入框
  Widget _inputText() {
    return TextFormField(
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
  }

  _faceBtnOnTap() {
    if (listener != null) {
      listener.emojiBtnOnTap();
    }
  }

  _moreBtnOnTap() {
    if (listener != null) {
      listener.moreBtnOnTap();
    }
  }

  _touchDown() {
    if (listener != null) {
      listener.voiceBtnTouchDown();
    }
  }

  _touchUpInside() {
    if (listener != null) {
      listener.voiceBtnTouchUpInside();
    }
  }

  _touchUpOutside() {
    if (listener != null) {
      listener.voiceBtnTouchUpOutside();
    }
  }

  _dragInside() {
    if (listener != null) {
      listener.voiceBtnDragInside();
    }
  }

  _dragOutside() {
    if (listener != null) {
      listener.voiceBtnDragOutside();
    }
  }

  _sendBtnDidClicked(String txt) {
    if (listener != null && txt.length > 0) {
      _textController.text = '';
      listener.sendBtnOnTap(txt);
    }
  }
}

abstract class ChatInputBarListener {
  /// 录音/文字按钮被点击
  void recordOrTextBtnOnTap();

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

  /// 发送按钮被点击
  void sendBtnOnTap(String str);
}
