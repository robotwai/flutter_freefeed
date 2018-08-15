import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constant.dart';
import 'dart:async';

class UserDetailPage extends StatefulWidget {
  int id;

  UserDetailPage(this.id);

  @override
  _UserDetailPageState createState() {
    return new _UserDetailPageState();
  }
}

class _UserDetailPageState extends State<UserDetailPage> {
  int barTextColor = 0x0000000f;
  int barBackgroundColor = 0xff00ff00;

  ScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()
      ..addListener(_scrollListener);
  }

  void _scrollListener() {
    //超过该高度则显示头部icon
    if (_scrollController.position.pixels > 40.0) {
      setState(() {
        barTextColor = 0xff00000f;
      });
    } else {
      setState(() {
        barTextColor = 0x0000000f;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Container(
          child: new Text("力争",
            style: new TextStyle(color: Color(barTextColor)),),
          color: Color(barBackgroundColor),
        ),
        backgroundColor: Color(barBackgroundColor),
        centerTitle: true,
      ),
      body: getList(),
    );
  }

  List<String> datas = [
    '1',
    '2',
    '3',
    '1',
    '2',
    '3',
    '1',
    '2',
    '3',
    '1',
    '2',
    '3',
    '1',
    '2',
    '3',
    '1',
    '2',
    '3',
    '1',
    '2',
    '3',
    '1',
    '2',
    '3',
    '1',
    '2',
    '3',
    '1',
    '2',
    '3',
  ];

  getList() {
    var content;

    content = new ListView.builder(
      itemCount: datas.length,
      itemBuilder: (context, i) {
        if (i == 0) {
          return new Column(
            children: <Widget>[
              new Container(
                child: new Text('123333'),
                color: Color(barBackgroundColor),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 100.0,
              ),
              new Container(
                color: Color(CLS.DIVIDER),
                height: 1.0,
              ),

            ],
          );
        } else {
          i -= 1;
          return new ListTile(title: new Text(datas[i]),);
        }
      },
      controller: _scrollController,
    );

    var _refreshIndicator = new RefreshIndicator(
        onRefresh: _refreshData,
        child: new Container(
          child: new GestureDetector(
            child: content,
            onTap: () {

            },
          ),
          margin: const EdgeInsets.only(bottom: 40.0),
        ));

    return _refreshIndicator;
  }

  Future<Null> _refreshData() {
    final Completer<Null> completer = new Completer<Null>();


    setState(() {});

    completer.complete(null);

    return completer.future;
  }
}
