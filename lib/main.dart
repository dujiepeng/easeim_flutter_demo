import 'package:easeim_flutter_demo/pages/account/register_page.dart';
import 'package:easeim_flutter_demo/pages/chat/chat_page.dart';
import 'package:easeim_flutter_demo/pages/index_page.dart';
import 'package:easeim_flutter_demo/pages/home_page.dart';
import 'package:easeim_flutter_demo/pages/account/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

void main() {
  SystemUiOverlayStyle uiStyle = SystemUiOverlayStyle.light;
  SystemChrome.setSystemUIOverlayStyle(uiStyle);
  WidgetsFlutterBinding.ensureInitialized();
  var options = EMOptions(appKey: 'easemob-demo#chatdemoui');
  EMClient.getInstance.init(options);
  return runApp(EaseIMDemo());
}

class EaseIMDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      designSize: Size(375, 667),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/login': (ctx) => LoginPage(),
          '/register': (ctx) => RegisterPage(),
          '/home': (ctx) => HomePage(),
          '/chat': (ctx, {arguments}) => ChatPage(chatId: arguments),
        },
        theme: ThemeData(
            appBarTheme: AppBarTheme(elevation: 1),
            buttonTheme: ButtonThemeData(
                minWidth: 44.0,
                highlightColor: Color.fromRGBO(0, 0, 0, 0),
                splashColor: Color.fromRGBO(0, 0, 0, 0)),
            highlightColor: Color.fromRGBO(0, 0, 0, 0),
            splashColor: Color.fromRGBO(0, 0, 0, 0)),
        home: IndexPage(),
      ),
    );
  }
}
