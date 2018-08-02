import 'package:flutter/material.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/utils/db_helper.dart';
import 'package:flutter_app/widget/feed.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/constant.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Account account;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }


  @override
  void initState() {
    super.initState();
    CommonSP.getAccount().then((onValue){
      setState(() {
        account = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      drawer: new Container(
        color: Color(0xFFFFFFFF),
        width: 250.0,
        child: new DrawLeftPage(account),
      ),
      body: new FeedPage(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DrawLeftPage extends StatelessWidget{

  Account account;
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Center(
              child: new ClipOval(
                child: new FadeInImage.assetNetwork(
                  placeholder: "images/shutter.png", //预览图
                  fit: BoxFit.fitWidth,
                  image: Constant.baseUrl + account.icon,
                  width: 80.0,
                  height: 80.0,
                ),
              ),
            ),
            width: 250.0,
            margin: const EdgeInsets.only(top: 40.0),
            padding: const EdgeInsets.only(top: 14.0,bottom: 6.0),

          ),
          new Container(
            child: new Center(
              child: Text(account.name,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003472),
                ),),
            ),
            width: 250.0,
            padding: const EdgeInsets.only(top: 8.0),
          ),
          new Container(
            child: new Center(
              child: Text(account.email,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003472),
                ),),
            ),
            width: 250.0,
            padding: const EdgeInsets.only(top: 14.0),
          ),

        ],
      ),
    );
  }

  DrawLeftPage(this.account);
}


class ImageTitle extends StatefulWidget{

  int picNum;
  int followerNum;
  int followedNum;
  String name;


  ImageTitle(this.picNum, this.followerNum, this.followedNum, this.name);

  @override
  State createState() {
    return new ImageTitleState();
  }
}


class ImageTitleState extends State<ImageTitle>{

  @override
  Widget build(BuildContext context) {
    widget.name;
    return new Container(
      color: new Color(0xFF0000FF),
      height: 100.0,
      child: new Column(
        children: <Widget>[
          Image.asset(
            'images/shutter.png',
            width: 40.0,
            height: 40.0,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}