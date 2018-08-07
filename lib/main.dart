import 'package:flutter/material.dart';
import 'package:flutter_app/widget/login.dart';
import 'package:flutter_app/widget/home.dart';
import 'package:flutter_app/widget/feed.dart';
import 'package:flutter_app/widget/add_micropost_page.dart';
import 'package:flutter_app/widget/register.dart';
import 'package:flutter_app/widget/setting.dart';

void main() => runApp(
    new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter'),
      routes: <String, WidgetBuilder> {
        '/a': (BuildContext context) => new MyHomePage(title: 'Free Feed'),
        '/b': (BuildContext context) => new FeedPage(title: 'the Feed'),
        '/c': (BuildContext context) => new LoginPage(),
        '/d': (BuildContext context) => new AddMicropostPage(),
        '/r': (BuildContext context) => new RegisterPage(),
        '/s': (BuildContext context) => new SettingPage(),
      },
    );
  }


}




