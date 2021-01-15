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
    Widget image;
    File file = File(body.localPath);

    if (direction == EMMessageDirection.SEND && file.existsSync()) {
      image = Image.file(
        file,
        fit: BoxFit.contain,
      );
    } else {
      // 作为接收方，是有图片size的，需要先根据size缩放
      double width = body.width;
      double height = body.height;

      if (height > width) {
        width = maxSize / height * width;
        height = maxSize;
      } else {
        height = maxSize / width * height;
        width = maxSize;
      }

      image = FadeInImage.assetNetwork(
        placeholder: 'images/chat_bubble_img_broken.png',
        image: body.thumbnailRemotePath,
        width: width,
        height: height,
      );
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
