import 'package:easeim_flutter_demo/unit/wx_expression.dart';
import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class ChatFaceView extends StatelessWidget {
  ChatFaceView(this.canDelete);

  final bool canDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(242, 242, 242, 1.0),
      ),
      width: double.infinity,
      height: sHeight(250),
      child: Stack(
        children: [
          Positioned(child: WeChatExpression((Expression expression) {})),
          Positioned(
            bottom: sHeight(20),
            right: sWidth(10),
            child: Container(
              height: sWidth(40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(242, 242, 242, 1.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0, 0),
                    color: Color.fromRGBO(242, 242, 242, 1.0),
                    blurRadius: sWidth(10),
                    spreadRadius: sWidth(5),
                  ),
                  BoxShadow(
                    offset: Offset(0, 30),
                    color: Color.fromRGBO(242, 242, 242, 1.0),
                    spreadRadius: sWidth(20),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: sWidth(60),
                    height: sWidth(45),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: FlatButton(
                      child: Image.asset(
                        'images/chat_faces_delete.png',
                        color: canDelete ? Colors.black87 : Colors.black26,
                        width: sWidth(25),
                        height: sWidth(20),
                        fit: BoxFit.fill,
                      ),
                      onPressed: () {
                        print('发送');
                      },
                    ),
                  ),
                  SizedBox(
                    width: sWidth(5),
                  ),
                  Container(
                    width: sWidth(60),
                    height: sWidth(45),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: canDelete
                          ? Color.fromRGBO(26, 184, 77, 1)
                          : Colors.white,
                    ),
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        print('发送');
                      },
                      child: Text(
                        '发送',
                        style: TextStyle(
                          color: canDelete ? Colors.white : Colors.black26,
                          fontSize: sFontSize(16),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
