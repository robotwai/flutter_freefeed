import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constant.dart';
import 'dart:async';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/widget/micropost_common_page.dart';
import 'package:flutter_app/network/common_http_client.dart';
import 'package:flutter_app/widget/user_detail_page.dart';
import 'package:flutter_app/widget/multi_touch_page.dart';
import 'package:flutter_app/widget/micropost_detail_page.dart';
import 'package:flutter_app/utils/db_helper.dart';

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
        title: new Text(widget.type == 0 ? '赞' : '推文广场'),
        centerTitle: true,
        backgroundColor: Color(CLS.BACKGROUND),
        elevation: 0.0,
      ),
      body: getList(),
    );
  }

  getList() {
    var content;
    double a =MediaQuery.of(context).size.height/2-80.0;
    a= a>0?a:a+80.0;
    content = new ListView.builder(
      addRepaintBoundaries: false,
      itemCount: datas.length==0?1:datas.length,
      itemBuilder: (context, i) {
        if(i==0&&datas.length==0){
          return new Container(
            width: MediaQuery.of(context).size.width,
            color: Color(CLS.BACKGROUND),
            padding:  EdgeInsets.only(top:a),
            child: new Center(
              child: new Column(
                children: <Widget>[
                  new Image.asset(
                    "images/blank.png",
                    fit: BoxFit.fitWidth,
                    width: 64.0,
                    height: 64.0,
                  ),
                  new Text(widget.type == 0 ? '还没有点过赞' : '发现更大的世界')
                ],
              ),
            ),
          );
        }else{
          final Micropost item = datas[i];
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

      },
      controller: _scrollController,
    );

    var _refreshIndicator = new Container(
      child: new RefreshIndicator(
          onRefresh: _refreshData,
          child: new Container(
            color: Color(CLS.BACKGROUND),
            child: new GestureDetector(
              child: content,
              onTap: () {},
            ),
          )),
      margin: const EdgeInsets.only(top: 10.0),
      color: const Color(0xffffffff),
    );

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
    if (widget.type == 0) {
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
    } else {
      FFHttpUtils.origin
          .getFindMicropostList(currentPage)
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
  jumpToUser(int id) {
    Navigator.of(context).push(new PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return new UserDetailPage(id);
      },
    ));
  }

  @override
  goPhotoView(String url) {
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

  void forDetailUpdate(Micropost item) async {
    Micropost m = await MicropostProvider.origin.getItem(item.id);
    updateSingleFeed(m);
  }

  @override
  void updateSingleFeed(Micropost item) {
    List<Micropost> l = [];
//    print(item.id.toString());
    l.add(item);
    setState(() {});
    addAndRemoveDuplicate(l);
  }
  @override
  tap_dot(Micropost item) {
    FFHttpUtils.origin.dot(item).then((onValue) {
      if (onValue != null) {
        MicropostProvider.origin.insert(onValue);
        updateSingleFeed(onValue);
      }
    });
  }
}
