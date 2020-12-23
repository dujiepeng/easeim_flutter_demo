import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  /// 输入框Controller
  final TextEditingController _textController = new TextEditingController();

  bool _voiceModel = false;
  bool _moreModel = false;
  bool _voiceBtnOnPressed = false;

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
              onPressed: () => {
                setState(() {
                  _voiceModel = !_voiceModel;
                })
              },
              child: Image.asset(
                _voiceModel
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
              color: _voiceBtnOnPressed
                  ? Color.fromRGBO(198, 198, 198, 1)
                  : Color.fromRGBO(245, 245, 245, 1),
            ),
            child: _voiceModel ? _recordButton() : _inputText(),
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
              onPressed: () => {print('表情')},
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
              onPressed: () => {
                setState(() {
                  _moreModel = !_moreModel;
                })
              },
              child: Image.asset(
                _moreModel
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
          top: sHeight(6),
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
    return TextField(
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
          sHeight(6),
          sWidth(16),
          sHeight(6),
        ),
        hintText: '请输入消息内容',
        hintStyle: TextStyle(
          fontSize: sFontSize(14),
          color: Colors.grey,
        ),
      ),
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

  _touchDown() {
    setState(() {
      _voiceBtnOnPressed = true;
    });
    print('按下');
  }

  _dragInside() {
    print('进入');
  }

  _dragOutside() {
    print('超出');
  }

  _touchUpInside() {
    print('内部抬起');
  }

  _touchUpOutside() {
    print('外部抬起');
  }
}
