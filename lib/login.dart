import 'package:flutter/material.dart';
import 'main.dart';
class Login extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Login",
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
      routes: <String, WidgetBuilder> {
        '/a': (BuildContext context) => new MyApp(),
      },
      home: new Center(
        child: new GestureDetector(
          child: new Text("this is login"),
          onTap: (){
            Navigator.of(context).pushNamed('/a');
          },
        )
      ),
    );
  }
}