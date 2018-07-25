import 'package:flutter/material.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/mvp/f_presenter.dart';
import 'package:flutter_app/mvp/f_presenter_impl.dart';
import 'package:flutter_app/sp_local.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
  MyFeedPageState createState(){
    MyFeedPageState myFeedPageState = new MyFeedPageState();
    FeedIPresenter presenter = new FeedPresenterImpl(myFeedPageState);
    presenter.init();
    return myFeedPageState;
  }
}

class MyFeedPageState extends State<FeedPage> implements FeedIView{
  List<Micropost> datas = [];

  final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);

  FeedIPresenter _presenter;
  String token;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('the Feed'),
      ),
      body: _buildSuggestions(),
    );
  }

  @override
  void initState() {
    super.initState();
    CommonSP.getAccount().then((onValue){
      token = onValue.token;
      _refreshData();
    });
  }

  Widget _buildSuggestions() {
    var content;

    if (datas.isEmpty) {
      content = new Center(child: new CircularProgressIndicator());
    } else {
      content = new ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: datas.length,
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

    datas.clear();
    _presenter.loadAIData(token, 1, 1);
    setState(() {});

    completer.complete(null);

    return completer.future;
  }
  void onloadFLSuc(List<Micropost> list){
    setState(() {
      datas.addAll(list);
    });
  }
  void onloadFLFail(){

  }

  @override
  setPresenter(FeedIPresenter presenter){
    _presenter = presenter;
  }

  Widget _buildRow(BuildContext context, int index) {
    final Micropost item = datas[index];
    print(item);
    return new ListTile(
      title: new Text(
        item.content,
        style: _biggerFont,
      ),
    );
  }
}