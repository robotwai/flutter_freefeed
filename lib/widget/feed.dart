import 'package:flutter/material.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/model/feed_model.dart';
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
  MyFeedPageState createState() => new MyFeedPageState();
}

class MyFeedPageState extends State<FeedPage>{
  List<Micropost> datas = [];

  final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  @override
  void initState() {
    super.initState();

    getaccount();
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



    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  void getaccount() async{
    CommonSP.getAccount().then((onValue){
      print(onValue.token);
      getlist(onValue.token);
      }
    );
  }

  void getlist(String token) async{
    var uri = new Uri.http(
        '192.168.45.58:3000', '/app/feed',
        {'token': token, 'page': '1'});
    print(uri.toString());

    var httpClient = new HttpClient();
    print('1');
    List flModels;
    try {
      var request = await httpClient.getUrl(uri);
      print('1');
      var response = await request.close();
      print('1');
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        print(json);
        flModels = jsonDecode(json)['data'];
        print(flModels);
        List<Micropost> list;
        List<Micropost> list1=[];

//        flModels.map((model) {
//          print(model);
////          list.add(new Micropost.fromJson(model)) ;
//        });
        list =flModels.map((model) {
          print(model);
          Micropost s= new Micropost.fromJson(model);
          list1.add(s);
          return new Micropost.fromJson(model);
        }).toList();
        print(list);
        print(list1);
        setState(() {
          datas.addAll(list);
        });

//        list.then((onValue){
//          setState(() {
//            datas.addAll(onValue);
//            print(datas);
//          });
//        });

      } else {
        //todo
        print('1');
      }
    } catch (exception) {
      //todo
      print(exception.toString());
    }
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