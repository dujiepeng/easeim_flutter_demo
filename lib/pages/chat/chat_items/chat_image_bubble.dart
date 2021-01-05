// 图片气泡

import 'dart:io';

import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ChatImageBubble extends StatelessWidget {
  ChatImageBubble(
    this.body, [
    this.direction = EMMessageDirection.SEND,
  ]);
  final EMImageMessageBody body;
  final EMMessageDirection direction;

  /// 最大长度
  final double maxSize = sWidth(160);

  @override
  Widget build(BuildContext context) {
    Image image;
    if (direction == EMMessageDirection.SEND) {
      image = Image.file(
        File(body.localPath),
        fit: BoxFit.contain,
      );
    } else {
      image = Image.network(body.thumbnailRemotePath);
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxSize,
        maxWidth: maxSize,
      ),
      child: image,
    );
  }
}
