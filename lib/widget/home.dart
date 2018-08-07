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
  Account account;
  String name;
  String email;
  String icon;
  String sign_content;
  int followed;
  int follower;
  FeedPage feedPage;

  void _addMicropost() {
    // This call to setState tells the Flutter framework that something has
    // changed in this State, which causes it to rerun the build method below
    // so that the display can reflect the updated values. If we changed
    // _counter without calling setState(), then the build method would not be
    // called again, and so nothing would appear to happen.
    if (account.token != '0') {
      Navigator.of(context).pushNamed('/d').then((onValue) {
        if (onValue == 1) {
          initState();
//          setState(() {
//            feedPage.myFeedPageState.initToken();
//          });
        }
      });
    } else {
      Navigator.of(context).pushNamed('/c').then((value) {
        if (value == 1) {
          print('login success');
          CommonSP.getAccount().then((onValue) {
            setState(() {
              account = onValue;
            });
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    CommonSP.getAccount().then((onValue) {
      setState(() {
        if (onValue != null) {
          account = onValue;
          name = account.name;
          email = account.email;
          icon = account.icon;
          sign_content = account.sign_content;
          followed = account.followed;
          follower = account.follower;
        }
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
    feedPage = new FeedPage();
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      drawer: new Container(
        color: Color(0xFFFFFFFF),
        width: 250.0,
        child: getLeftPage(),
      ),
      body: feedPage,
      floatingActionButton: new FloatingActionButton(
        onPressed: _addMicropost,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getLeftPage() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new GestureDetector(
            onTap: _tap_icon,
            child: new Container(
              child: new Center(
                child: new ClipOval(
                  child: getLeftIcon(),
                ),
              ),
              width: 250.0,
              margin: const EdgeInsets.only(top: 40.0),
              padding: const EdgeInsets.only(top: 14.0, bottom: 6.0),
            ),
          ),
          new Container(
            child: new Center(
              child: Text(
                name == null ? 'xxx' : name,
                style: new TextStyle(
                    fontWeight: FontWeight.w600,
                  color: Color(0xFF003472),
                    fontSize: 17.0
                ),
              ),
            ),
            width: 250.0,
            padding: const EdgeInsets.only(top: 8.0),
          ),
          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.ltr,
              children: <Widget>[
                new Container(
                  child: new Text(
                    followed == null ? 'xxx' : "正在关注" + followed.toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF50616D),
                        fontSize: 14.0
                    ),
                  ),
                  margin: const EdgeInsets.only(right: 6.0),
                ),
                new Container(
                  child: new Text(
                    follower == null ? 'xxx' : "关注者" + follower.toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF50616D),
                        fontSize: 14.0
                    ),
                  ),
                  margin: const EdgeInsets.only(left: 6.0),
                ),
              ],
            ),
            width: 250.0,
            padding: const EdgeInsets.only(top: 14.0),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 14.0),
            child: new Column(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.person),
                  title: new Text("个人资料"),
                ),
                new ListTile(
                  leading: new Icon(Icons.bookmark),
                  title: new Text("收藏"),
                ),
                new ListTile(
                  leading: new Icon(Icons.settings),
                  title: new Text("设置"),
                  onTap: jumpToSetting,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void jumpToSetting() {
    Navigator.of(context).pushNamed('/s').then((onValue) {
      if (onValue == 1) {
        initState();
      }
    });
  }

  Widget getLeftIcon() {
    if (icon == null) {
      return new Image.asset(
        "images/shutter.png",
        fit: BoxFit.fitWidth,
        width: 80.0,
        height: 80.0,
      );
    } else {
      return new FadeInImage.assetNetwork(
        placeholder: "images/shutter.png", //预览图
        fit: BoxFit.fitWidth,
        image: Constant.baseUrl + icon,
        width: 80.0,
        height: 80.0,
      );
    }
  }

  void _tap_icon() async {
    if (account == null || account.token == '0') {
      Navigator.of(context).pushNamed('/c').then((value) {
        if (value == 1) {
          print('login success');
          CommonSP.getAccount().then((onValue) {
            setState(() {
              account = onValue;
            });
          });
        }
      });
    }
  }
}
