import 'package:flutter/material.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/mvp/f_presenter.dart';
import 'package:flutter_app/mvp/f_presenter_impl.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/utils/db_helper.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/utils/time_utils.dart';
import 'package:flutter_app/widget/multi_touch_page.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  MyFeedPageState createState() {
    MyFeedPageState myFeedPageState = new MyFeedPageState();
    FeedIPresenter presenter = new FeedPresenterImpl(myFeedPageState);
    presenter.init();
    return myFeedPageState;
  }
}

class MyFeedPageState extends State<FeedPage> implements FeedIView {
  List<Micropost> datas = [];

  final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);

  FeedIPresenter _presenter;
  String token;

  ScrollController _scrollController;

  int curPageNum = 1;
  bool isFullLoad = false;
  @override
  Widget build(BuildContext context) {
    return  _buildSuggestions();

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
  void initState() {
    super.initState();

    CommonSP.getAccount().then((onValue) {
      token = onValue.token;
      _refreshData();
    });

    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  Widget _buildSuggestions() {
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

  Future<Null> _refreshData() {
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
//        List<Micropost> list1 =pastLeep1(datas);
//        datas.clear();
//        datas.addAll(list1);
    });
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

  Widget _buildRow(BuildContext context, int index) {
    final Micropost item = datas[index];
    return new Card(
      margin: const EdgeInsets.all(10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Row(
            children: <Widget>[
              new Container(
                child: new ClipOval(
                  child: new FadeInImage.assetNetwork(
                    placeholder: "images/shutter.png", //预览图
                    fit: BoxFit.fitWidth,
                    image: Constant.baseUrl + item.icon,
                    width: 60.0,
                    height: 60.0,
                  ),
                ),
                margin: const EdgeInsets.all(12.0),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: new Text(
                      item.user_name,
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003472),
                      ),
                    ),
                  ),
                  new Text(
                    TimeUtils.CalculateTime(item.created_at),
                    style: new TextStyle(
                      color: Color(0xFF50616D),
                    ),
                  ),
                ],
              ),
            ],
          ),
          new Container(
            child: new Text(
              item.content,
              style: new TextStyle(
                color: Color(0xFF000000),
                fontSize: 16.0,
              ),
            ),
            margin: const EdgeInsets.all(12.0),
          ),
          new Center(
            child: new GestureDetector(
              onTap: () {
                _goPhotoView(item.picture);
              },
              child: new Card(
                child: _getImageChild(item.picture),
              ),
            ),
          ),
          new Container(
            child: new Divider(
              height: 1.0,
              color: Color(0xFFe0e0e0),
            ),
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 16.0,right: 16.0),
          ),

          _getBottomView(item),
        ],
      ),
    );
  }

  _getImageChild(String url) {
    if ((Constant.baseUrl + url).contains('null')) {
      return new Container();
    }
    {
      return new Image.network(Constant.baseUrl + url);
    }
  }

  _getBottomView(Micropost item) {
    bool yizan = item.dotId > 0;
    int zanNum = item.dots_num;
    int commitNum = item.comment_num;
    int zhuanfaNum = 123;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  yizan ? 'images/yizan.png' : 'images/dianzan.png',
                  width: 15.0,
                  height: 15.0,
                ),
                new Container(
                  child: new Text('$zanNum'),
                  margin: const EdgeInsets.only(left: 4.0),
                )
              ],
            ),
          ),
          new Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/pinglun.png',
                  width: 15.0,
                  height: 15.0,
                ),
                new Container(
                  child: new Text('$commitNum'),
                  margin: const EdgeInsets.only(left: 4.0),
                )
              ],
            ),
          ),
          new Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/zhuanfa.png',
                  width: 15.0,
                  height: 15.0,
                ),
                new Container(
                  child: new Text('$zhuanfaNum'),
                  margin: const EdgeInsets.only(left: 4.0),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goPhotoView(String url) {
    if ((Constant.baseUrl + url).contains('null')) {
      return;
    }
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new MultiTouchPage(Constant.baseUrl + url);
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
}
