import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class ChatMoreView extends StatelessWidget {
  ChatMoreView(
    this.list, {
    int rowCount = 4,
    int columnCount = 2,
    bool autoHeight = true,
  })  : _rowCount = rowCount,
        _columnCount = columnCount,
        _autoHeight = autoHeight;

  final List<ChatMoreViewItem> list;

  /// 横向总间隔
  final double _allHorizontalPadding = sWidth(10);

  /// 纵向总间距
  final double _allVerticalPadding = sHeight(10);

  /// 列数
  final int _rowCount;

  /// 行数
  final int _columnCount;

  /// 每个item高度
  final double _itemHeight = sHeight(67);

  /// 当设置的item个数不满足行数的时候，自动适应高度
  final bool _autoHeight;

  @override
  Widget build(BuildContext context) {
    double cellWidth =
        ((MediaQuery.of(context).size.width - _allHorizontalPadding) /
            _rowCount);
    double height = 0;
    if (_autoHeight) {
      height =
          _allVerticalPadding + ((list.length ~/ _rowCount) + 1) * _itemHeight;
    } else {
      height = _allVerticalPadding + _columnCount * _itemHeight;
    }

    return Container(
      color: Color.fromRGBO(248, 248, 248, 1),
      width: MediaQuery.of(context).size.width,
      height: height,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisSpacing: _allHorizontalPadding / (_rowCount - 1),
        mainAxisSpacing: _allVerticalPadding,
        //GridView内边距
        padding: EdgeInsets.only(
          left: sWidth(20),
          right: sWidth(20),
          top: sHeight(12),
          bottom: sHeight(12),
        ),
        //一行的Widget数量
        crossAxisCount: _rowCount,

        //子Widget宽高比例
        childAspectRatio: cellWidth / _itemHeight,
        //子Widget列表
        children: getItemWidgetList(),
      ),
    );
  }

  List<Widget> getItemWidgetList() {
    return list.map((item) => getItemWidget(item)).toList();
  }

  Widget getItemWidget(ChatMoreViewItem item) {
    return Container(
      height: _itemHeight,
      // color: Colors.blue,
      child: GestureDetector(
        onTapUp: (TapUpDetails details) {
          if (item.onTap != null) item.onTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(
                sWidth(10),
              ),
              width: sWidth(55),
              height: sWidth(55),
              child: Image.asset(item.imageName),
            ),
            SizedBox(
              height: sHeight(2),
            ),
            Text(
              item.label,
              style: TextStyle(
                color: Color.fromRGBO(153, 153, 153, 1),
                fontSize: sFontSize(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMoreViewItem {
  ChatMoreViewItem(this.imageName, this.label, this.onTap);
  final String imageName;
  final String label;
  VoidCallback onTap;
}
