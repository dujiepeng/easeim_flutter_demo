import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ContactsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  List<EMContact> _contactList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    fetchContactsFromServer();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Title(
          color: Colors.white,
          child: Text(
            '通讯录',
          ),
        ),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: () => fetchContactsFromServer(),
          child: ListView.separated(
            separatorBuilder: (_, int index) {
              return Container(
                margin: EdgeInsets.only(left: 50),
                height: 0.1,
                color: Colors.red,
              );
            },
            itemBuilder: (_, int index) => getContactRow(index),
            itemCount: _contactList.length,
          ),
        ),
      ),
    );
  }

  Widget getContactRow(int index) {
    return GestureDetector(
      onTap: () {},
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 15,
                top: 10,
                bottom: 10,
              ),
              width: 50,
              height: 50,
              child: Image.asset('images/logo.png'),
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: 60,
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 5),
              child: Text(
                _contactList[index].nickname,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                maxLines: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> fetchContactsFromServer() async {
    try {
      List<EMContact> contacts =
          await EMClient.getInstance.contactManager.getAllContactsFromServer();
      _contactList.clear();
      _contactList.addAll(contacts);
    } on EMError {
      Fluttertoast.showToast(msg: '获取失败');
    } finally {
      setState(() {});
    }
  }
}
