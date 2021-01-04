// 图片气泡

import 'package:easeim_flutter_demo/widgets/asperct_raio_image.dart';
import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ChatImageBubble extends StatelessWidget {
  ChatImageBubble(
    this.body,
  );
  final EMImageMessageBody body;

  /// 最大长度
  final double maxSize = sWidth(180);

  @override
  Widget build(BuildContext context) {
    double width = sWidth(body.width);
    double height = sHeight(body.height);

    print(body.localPath);
    return AsperctRaioImage.asset(
      body.localPath,
      builder: (context, snapshot, file) {
        // 计算宽高
        if (width > height) {
          height = maxSize / width * height;
          width = maxSize;
        } else {
          width = maxSize / height * width;
          height = maxSize;
        }
        return Container();
      },
    );
  }
}
