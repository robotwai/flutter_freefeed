import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constant.dart';
import 'dart:async';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/widget/micropost_common_page.dart';
import 'package:flutter_app/network/common_http_client.dart';

class MicropostListPage extends StatefulWidget {
  int id;
  int type;

  MicropostListPage(this.id, this.type);

  @override
  State createState() {
    return new _MicropostListPageState();
  }
}

class _MicropostListPageState extends State<MicropostListPage>
    implements PageCallBack {
  List<Micropost> datas = [];
  int currentPage = 1;
  bool isFullLoad = false;
  ScrollController _scrollController;

  @override
  void initState() {
    _refreshData();
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    //超过该高度则显示头部icon
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

  Future<Null> _loadData() {
    final Completer<Null> completer = new Completer<Null>();

    currentPage = currentPage + 1;

    loadMicroposts();

    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('赞'),
        centerTitle: true,
        backgroundColor: Color(CLS.BACKGROUND),
        elevation: 0.0,
      ),
      backgroundColor: Color(CLS.BACKGROUND),
      body: getList(),
    );
  }

  getList() {
    var content;

    content = new ListView.builder(
      addRepaintBoundaries: false,
      itemCount: datas.length,
      itemBuilder: (context, i) {
        final Micropost item = datas[i];
        return new GestureDetector(
          child: new Card(
            color: Color(CLS.BACKGROUND),
            margin: const EdgeInsets.all(10.0),
            child: new MicropostPage(item, this, 1),
          ),
          onTap: () {
//            jumpToDetail(item);
          },
        );
      },
      controller: _scrollController,
    );

    var _refreshIndicator = new RefreshIndicator(
        onRefresh: _refreshData,
        child: new Container(
          color: Color(CLS.BACKGROUND),
          child: new GestureDetector(
            child: content,
            onTap: () {},
          ),
        ));

    return _refreshIndicator;
  }

  Future<Null> _refreshData() {
    final Completer<Null> completer = new Completer<Null>();
    currentPage = 1;
    loadMicroposts();
    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  loadMicroposts() {
    FFHttpUtils.origin
        .getDotMicropostList(widget.id, currentPage)
        .then((onValue) {
      if (onValue != null && onValue.length > 0) {
        if (onValue.length < 30) {
          isFullLoad = true;
        } else {
          isFullLoad = false;
        }
        setState(() {
          print('onloadFLSuc');
          addAndRemoveDuplicate(onValue);
        });
      }
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

  @override
  jumpToUser(int id) {}

  @override
  goPhotoView(String url) {}

  @override
  jumpToDetail(Micropost item) {}

  @override
  tap_dot(Micropost item) {}
}
