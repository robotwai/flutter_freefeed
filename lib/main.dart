import 'package:flutter/material.dart';
import 'package:flutter_app/widget/login.dart';
import 'package:flutter_app/widget/home.dart';
import 'package:flutter_app/widget/feed.dart';
import 'package:flutter_app/utils/db_helper.dart';
import 'dart:async';
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
      },
    );
  }


}
class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{

  @override
  void initState() {
    MicropostProvider.origin;
    new Future.delayed(const Duration(seconds:2), () {
      //任务具体代码
//      Navigator.of(context).pushNamed('/a');
//    setState(() {
      Navigator.of(context).popAndPushNamed('/a');
//    });
//      Navigator.of(context).pop();

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Image.asset(
      'images/lz_splash.png',
      width: 900.0,
      height: 1920.0,
      fit: BoxFit.cover,
    );
  }

}



