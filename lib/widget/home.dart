import 'package:flutter/material.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/utils/db_helper.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/mvp/f_presenter.dart';
import 'package:flutter_app/mvp/f_presenter_impl.dart';
import 'package:flutter_app/utils/time_utils.dart';
import 'package:flutter_app/widget/multi_touch_page.dart';
import 'dart:async';
import 'package:flutter_app/widget/micropost_detail_page.dart';
import 'package:flutter_app/widget/micropost_common_page.dart';
import 'package:flutter_app/widget/user_detail_page.dart';

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
  _MyHomePageState myFeedPageState;
  @override
  _MyHomePageState createState() {
    myFeedPageState = new _MyHomePageState();
    FeedIPresenter presenter = new FeedPresenterImpl(myFeedPageState);
    presenter.init();
    return myFeedPageState;
  }
}

class _MyHomePageState extends State<MyHomePage>
    implements FeedIView, PageCallBack {
  Account account;
  String name;
  String email;
  String icon;
  String sign_content;
  int followed;
  int follower;
  String token = '0';
  FeedIPresenter _presenter;
  ScrollController _scrollController;

  int curPageNum = 1;
  bool isFullLoad = false;
  List<Micropost> datas = [];

  void _addMicropost() {
    // This call to setState tells the Flutter framework that something has
    // changed in this State, which causes it to rerun the build method below
    // so that the display can reflect the updated values. If we changed
    // _counter without calling setState(), then the build method would not be
    // called again, and so nothing would appear to happen.
    if (account.token != '0') {
      Navigator.of(context).pushNamed('/d').then((onValue) {
        if (onValue == 1) {
          getUserInfo();
//          setState(() {

//          });
        }
      });
    } else {
      Navigator.of(context).pushNamed('/c').then((value) {
        if (value == 1) {
          print('login success');
          getUserInfo();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    _lastClickTime = 0;
    _scrollController = new ScrollController()
      ..addListener(_scrollListener);
  }

  void getUserInfo() async {
    await MicropostProvider.origin.initAA();
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
          token = account.token;
        } else {
          account = null;
          name = null;
          email = null;
          icon = null;
          sign_content = null;
          followed = null;
          follower = null;
          token = '0';
        }
        _refreshData();
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isFullLoad) {
        _loadData();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(
            widget.title,
            style: new TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        drawer: new Container(
          color: Color(CLS.BACKGROUND),
          width: 250.0,
          child: getLeftPage(),
        ),
        body: _buildFeeds(),
        floatingActionButton: new FloatingActionButton(
          onPressed: _addMicropost,
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
      onWillPop: _doubleExit,
    );
  }

  Widget _buildFeeds() {
    var content;

    if (datas.isEmpty) {
      content = new Center(child: new CircularProgressIndicator());
    } else {
      content = new ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: datas.length,
        controller: _scrollController,
        itemBuilder: _buildRow,
      );
    }

    var _refreshIndicator = new RefreshIndicator(
      onRefresh: _refreshData,
      child: content,
    );

    return _refreshIndicator;
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
                    fontSize: 17.0),
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
                    followed == null ? 'xxx' : "正在关注 " + followed.toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF50616D),
                        fontSize: 14.0),
                  ),
                  margin: const EdgeInsets.only(right: 6.0),
                ),
                new Container(
                  child: new Text(
                    follower == null ? 'xxx' : "关注者 " + follower.toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF50616D),
                        fontSize: 14.0),
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

  Widget _buildRow(BuildContext context, int index) {
    final Micropost item = datas[index];
    return new GestureDetector(
      child: new Card(
        color: Color(CLS.BACKGROUND),
        margin: const EdgeInsets.all(10.0),
        child: new MicropostPage(item, this, 1),
      ),
      onTap: () {
        jumpToDetail(item);
      },
    );
  }

  void jumpToSetting() {
    Navigator.of(context).pushNamed('/s').then((onValue) {
      if (onValue == 1) {
        print("getUserInfo");
        getUserInfo();
      }
    });
  }

  void jumpToDetail(Micropost item) {
    Navigator
        .of(context)
        .push(new PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return new MicropostDetailPage(item);
      },
    ))
        .then((onValue) {
      forDetailUpdate(item);
    });
  }


  @override
  jumpToUser(int id) {
    Navigator
        .of(context)
        .push(new PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return new UserDetailPage(id);
      },
    ));
  }

  void forDetailUpdate(Micropost item) async {
    Micropost m = await MicropostProvider.origin.getItem(item.id);
    print(m);
    updateSingleFeed(m);
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

  void goPhotoView(String url) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new MultiTouchPage(url);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new RotationTransition(
              turns: new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        }));
  }

  @override
  void _tap_icon() {
    if (account == null || account.token == '0') {
      Navigator.of(context).pushNamed('/c').then((value) {
        if (value == 1) {
          print('login success');
          print("getUserInfo");
          getUserInfo();
        }
      });
    } else {
      jumpToUser(account.id);
    }
  }

  @override
  tap_dot(Micropost item) {
    _presenter.dot(token, item);
  }

  Future<Null> _refreshData() {
    print('_refreshData');
    final Completer<Null> completer = new Completer<Null>();

    curPageNum = 1;
    _presenter.loadAIData(token, curPageNum, 1);
    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  Future<Null> _loadData() {
    final Completer<Null> completer = new Completer<Null>();

    curPageNum = curPageNum + 1;

    _presenter.loadAIData(token, curPageNum, 1);

    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  void onloadFLSuc(List<Micropost> list) {
    if (list.length < 30) {
      isFullLoad = true;
    } else {
      isFullLoad = false;
    }
    setState(() {
      print('onloadFLSuc');
      addAndRemoveDuplicate(list);
    });
  }

  @override
  void updateSingleFeed(Micropost item) {
    List<Micropost> l = [];
    print(item.id.toString());
    l.add(item);
    setState(() {});
    addAndRemoveDuplicate(l);
  }

  void addAndRemoveDuplicate(List<Micropost> list) {
    for (Micropost micropost in list) {
      for (Micropost mic in datas) {
        if (mic.id == micropost.id) {
          datas.remove(mic);
          break;
        }
      }
    }
    datas.addAll(list);
    datas.sort((a, b) => b.id.compareTo(a.id));
  }

  void onloadFLFail() {
    setState(() {
      print('onloadFLFail');
    });
  }

  @override
  setPresenter(FeedIPresenter presenter) {
    _presenter = presenter;
  }

  int _lastClickTime;

  Future<bool> _doubleExit() {
    int nowTime = new DateTime.now().microsecondsSinceEpoch;

    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      return new Future.value(true);
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });

      return new Future.value(false);
    }
  }
}
