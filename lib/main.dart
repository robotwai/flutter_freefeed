import 'package:flutter/material.dart';
import 'package:flutter_app/widget/login.dart';
import 'package:flutter_app/widget/home.dart';
import 'package:flutter_app/widget/add_micropost_page.dart';
import 'package:flutter_app/widget/register.dart';
import 'package:flutter_app/widget/setting.dart';
import 'package:flutter_app/utils/constant.dart';

void main() => runApp(
    new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(CLS.ACTIONBAR),
        accentColor: Color(CLS.ACTIONBAR),
      ),
      home: new MyHomePage(title: 'Free Feed'),
      routes: <String, WidgetBuilder> {
        '/a': (BuildContext context) => new MyHomePage(title: 'Free Feed'),
        '/c': (BuildContext context) => new LoginPage(),
        '/d': (BuildContext context) => new AddMicropostPage(),
        '/r': (BuildContext context) => new RegisterPage(),
        '/s': (BuildContext context) => new SettingPage(),
      },
    );
  }


}




