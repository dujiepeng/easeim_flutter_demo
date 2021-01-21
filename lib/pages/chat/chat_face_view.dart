import 'package:easeim_flutter_demo/unit/wx_expression.dart';
import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class ChatFaceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: sHeight(250),
      child: Stack(
        children: [
          Positioned(child: WeChatExpression((Expression expression) {})),
          Positioned(
            bottom: sHeight(20),
            right: sWidth(10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: IconButton(
                    color: Colors.black26,
                    icon: Icon(Icons.delete_rounded),
                    onPressed: () {
                      print('删除');
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: FlatButton(
                    onPressed: () {
                      print('发送');
                    },
                    child: Text(
                      '发送',
                      style: TextStyle(color: Colors.black26),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
