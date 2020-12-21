import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class MePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MePageState();
}

class MePageState extends State<MePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          child: Text(
            '会话',
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, int index) {
          return slidableItem(
            margin: EdgeInsets.only(top: 10),
            child: Container(
              height: 60,
              color: Colors.blue,
            ),
            actions: [
              slidableDeleteAction(),
              slidableNormalAction(color: Colors.blue)
            ],
          );
        },
        itemCount: 10,
      ),
    );
  }
}
