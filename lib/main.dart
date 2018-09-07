import 'package:flutter/material.dart';
import 'package:flutter_app/widget/login.dart';
import 'package:flutter_app/widget/home.dart';
import 'package:flutter_app/widget/add_micropost_page.dart';
import 'package:flutter_app/widget/register.dart';
import 'package:flutter_app/widget/setting.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/utils/app_state.dart';

void main() => runApp(
    new MyInheritedApp());


class MyInheritedApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //因为是AppState，所以他的范围是全生命周期的，所以可以直接包裹在最外层
    return AppStateContainer(
      //初始化一个loading
      state: AppState.loading(),
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(CLS.ACTIONBAR),
          accentColor: Color(CLS.ACTIONBAR),
        ),
        debugShowCheckedModeBanner: false,
        home: new MyHomePage(title: '首页'),
        routes: <String, WidgetBuilder>{
          '/a': (BuildContext context) => new MyHomePage(title: '首页'),
          '/c': (BuildContext context) => new LoginPage(),
          '/d': (BuildContext context) => new AddMicropostPage(),
          '/r': (BuildContext context) => new RegisterPage(),
          '/s': (BuildContext context) => new SettingPage(),
        },
      ),
    );
  }
}






