import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'dart:math' as math;

class ChatVoiceBubble extends StatelessWidget {
  ChatVoiceBubble(
    this.body, [
    this.direction = EMMessageDirection.SEND,
  ]);
  final EMVoiceMessageBody body;
  final EMMessageDirection direction;

  /// 最大长度
  final double maxSize = sWidth(220);

  /// 最小长度, 设置最小长度时要注意波纹图片的长度可能大于最小长度，所以不能设置的太小。
  final double minSize = sWidth(65);

  @override
  Widget build(BuildContext context) {
    double width = minSize * body.duration / 15;
    if (width < minSize) width = minSize;
    if (width > maxSize) width = maxSize;
    return Container(
      padding: EdgeInsets.only(
        left: sWidth(10),
        right: sWidth(10),
      ),
      constraints: BoxConstraints(
        maxHeight: 40,
        maxWidth: width,
      ),
      child: Row(
        textDirection: direction == EMMessageDirection.SEND
            ? TextDirection.ltr
            : TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${body.duration}s',
          ),
          Container(
            margin: EdgeInsets.only(
              top: sWidth(10),
              bottom: sWidth(10),
            ),
            child: Transform.rotate(
              angle: direction == EMMessageDirection.SEND ? 0 : math.pi,
              child: SizedBox(
                width: sWidth(20),
                height: sWidth(20),
                child: Image.asset(
                  'images/chat_bubble_voice_ripple.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
