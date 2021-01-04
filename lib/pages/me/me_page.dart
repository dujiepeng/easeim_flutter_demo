import 'package:flutter/material.dart';

class MePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MePageState();
}

class MePageState extends State<MePage> {
  double _top = 0.0; //距顶部的偏移
  double _left = 0.0; //距左边的偏移
  bool boolColor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DragTest"),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: _top,
            left: _left,
            child: GestureDetector(
              child: CircleAvatar(
                  backgroundColor: boolColor ? Colors.red : Colors.green,
                  child: Text("Draggable Text", textAlign: TextAlign.center),
                  radius: 50),
              //手指按下时会触发此回调
              onPanDown: (DragDownDetails e) {
                setState(() {
                  boolColor = true;
                });
                //打印手指按下的位置(屏幕)
                print("用户手指按下：${e.globalPosition}");
              },
              //手指滑动时会触发此回调
              onPanUpdate: (DragUpdateDetails e) {
                //用户手指滑动时，更新偏移，重新构建
                setState(() {
                  _left += e.delta.dx;
                  _top += e.delta.dy;
                });
              },
              onPanEnd: (DragEndDetails e) {
                setState(() {
                  boolColor = false;
                });
                //打印滑动结束时在x、y轴上的速度
                print(e.velocity);
              },
            ),
          ),
          Positioned(
            bottom: 100,
            left: 100,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red,
              child: Image.network(
                "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=805208618,905828614&fm=26&gp=0.jpg",
                height: 300,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );

                  // return AnimatedOpacity(
                  //   child: child,
                  //   opacity: frame == null ? 0 : 1,
                  //   duration: const Duration(seconds: 2),
                  //   curve: Curves.easeOut,
                  // );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
