import 'package:flutter/material.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/utils/time_utils.dart';
import 'package:flutter_app/widget/micropost_common_page.dart';
import 'package:flutter_app/mvp/m_presenter.dart';
import 'package:flutter_app/model/commit_model.dart';
import 'package:flutter_app/mvp/m_presenter.impl.dart';
import 'dart:async';
import 'package:flutter_app/widget/Indicator_line.dart';
import 'package:flutter_app/model/dot_model.dart';

class MicropostDetailPage extends StatefulWidget {
  Micropost micropost;
  _MicropostDetailState myMicropostDetailState;
  @override
  _MicropostDetailState createState() {
    myMicropostDetailState = new _MicropostDetailState(micropost);
    MicropostIPresenter presenter = new MicropostPresenterImpl(
        myMicropostDetailState);
    presenter.init();
    return myMicropostDetailState;
  }

  MicropostDetailPage(this.micropost);
}

class _MicropostDetailState extends State<MicropostDetailPage>
    with SingleTickerProviderStateMixin
    implements PageCallBack, MicropostIView {
  Account account;
  Micropost micropost;
  MicropostIPresenter _presenter;
  ScrollController _scrollController;
  List<Commit> commitDatas = [];
  List<Dot> dotDatas = [];
  int curPageNum = 1;
  _MicropostDetailState(this.micropost);

  bool isShowTitle = false;
  @override
  void initState() {
    CommonSP.getAccount().then((onValue) {
      account = onValue;
    });
    _scrollController = new ScrollController()
      ..addListener(_scrollListener);
    _refreshData();
  }

  int Indicator_index = 1;
  @override
  Widget build(BuildContext context) {
    var node = new FocusNode();
    return new Scaffold(
        appBar: getAppBar(),
        body: getList(),
        bottomNavigationBar: new Container(
          height: 60.0,
          child: new TextField(
            onChanged: (str) {

            },
            decoration: new InputDecoration(
                labelText: '邮箱',
                hintText: '请输入邮箱',
                labelStyle:
                new TextStyle(color: Color(CLS.TextLabel))),
            maxLines: 1,
            onSubmitted: (text) {
              FocusScope.of(context).reparentIfNeeded(node);
            },
          ),
        )
    );
  }

  void _scrollListener() {
    //超过该高度则显示头部icon
    if (_scrollController.position.pixels > 40.0) {
      setState(() {
        isShowTitle = true;
      });
    } else {
      setState(() {
        isShowTitle = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  Widget getAppBar() {
    return new AppBar(
      title: new Container(
        child: new Center(
            child: Offstage(
              offstage: !isShowTitle,
              child: new ClipOval(
                child: _getTopIcon(),
              ),
            )),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      leading: new IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Color(0xFF000000),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.more_horiz),
          color: Color(0xFF000000),
          onPressed: () {
//              _sendMicropost();
          },
        ),
      ],
    );
  }

  Widget getTabs() {
    int a = micropost.dots_num;
    int b = micropost.comment_num;
    int c = 123;
    return new Row(
      children: <Widget>[
        new GestureDetector(
          child: new Container(
            child: new Center(
              child: new Text("赞  " + '$a',
                style: TextStyle(
                    color: Indicator_index == 1 ? Color(CLS.INDICATOR) : Color(
                        CLS.TextLabel)),),
            ),
            width: (MediaQuery
                .of(context)
                .size
                .width) / 3,
            height: 40.0,
          ),
          onTap: () {
            sw(1);
          },
        ),
        new GestureDetector(
          child: new Container(
            child: new Center(
              child: new Text("评论 " + '$b',
                  style: TextStyle(color: Indicator_index == 2
                      ? Color(CLS.INDICATOR)
                      : Color(CLS.TextLabel))),
            ),
            width: (MediaQuery
                .of(context)
                .size
                .width) / 3,
            height: 40.0,
          ),
          onTap: () {
            sw(2);
          },
        ),
        new GestureDetector(
          child: new Container(
            child: new Center(
              child: new Text("转发 " + '$c',
                  style: TextStyle(color: Indicator_index == 3
                      ? Color(CLS.INDICATOR)
                      : Color(CLS.TextLabel))),
            ),
            width: (MediaQuery
                .of(context)
                .size
                .width) / 3,
            height: 40.0,
          ),
          onTap: () {
            sw(3);
          },
        ),
      ],
    );
  }
  Widget _getTopIcon() {
    print(micropost.icon);
    if (micropost == null ||
        micropost.icon == null ||
        micropost.icon == 'null') {
      return new Image.asset(
        "images/shutter.png",
        width: 36.0,
        height: 36.0,
      );
    } else {
      return new FadeInImage.assetNetwork(
        placeholder: "images/shutter.png",
        //预览图
        fit: BoxFit.fitWidth,
        image: Constant.baseUrl + micropost.icon,
        width: 36.0,
        height: 36.0,
      );
    }
  }

  sw(int index) {
    print(index.toString());
    setState(() {
      Indicator_index = index;
      _refreshData();
    });
  }

  List datas = [];

  Widget getList() {
    var content;

    if (Indicator_index == 1) {
      datas = dotDatas;
    } else {
      datas = commitDatas;
    }
    content = new ListView.builder(
      itemCount: datas.length == 0 ? 1 : datas.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return new Column(
            children: <Widget>[
              new MicropostPage(micropost, this),
              new Container(
                color: Color(CLS.DIVIDER),
                height: 14.0,
              ),
              getTabs(),
              new Container(
                child: new CustomPaint(
                  painter: new IndicatorLine(Indicator_index, 3, MediaQuery
                      .of(context)
                      .size
                      .width),
                  isComplex: true,),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 6.0,
              ),

            ],
          );
        } else {
          i -= 1;
          if (Indicator_index == 1) {
            return _buildRow1(context, i);
          } else {
            return _buildRow2(context, i);
          }
        }
      },
      controller: _scrollController,
    );


    var _refreshIndicator = new RefreshIndicator(
      onRefresh: _refreshData,
        child: content

    );

    return _refreshIndicator;
  }

  Widget _buildRow1(BuildContext context, int index) {
    Dot dot = datas[index];
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Row(
          children: <Widget>[
            new GestureDetector(
              child: new Container(
                child: new ClipOval(
                  child: getIcon(dot.icon == null ? "null" : dot.icon),
                ),
                margin: const EdgeInsets.all(12.0),
              ),
              onTap: () {
                print("tap");
              },
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    dot.user_name,
                    style: new TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF003472),
                        fontSize: 12.0),
                  ),
                ),
                new Text(
                  TimeUtils.CalculateTime(dot.created_at),
                  style:
                  new TextStyle(color: Color(0xFF50616D), fontSize: 10.0),
                ),
              ],
            ),
          ],
        ),
        new Container(
          child: new Divider(),
//          margin: const EdgeInsets.only(left: 60.0,bottom: 2.0),
        ),
      ],
    );
  }


  Widget _buildRow2(BuildContext context, int index) {
    Commit commit = datas[index];
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Row(
          children: <Widget>[
            new GestureDetector(
              child: new Container(
                child: new ClipOval(
                  child: getIcon(commit.icon == null ? "null" : commit.icon),
                ),
                margin: const EdgeInsets.all(12.0),
              ),
              onTap: () {
                print("tap");
              },
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    commit.user_name,
                    style: new TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF003472),
                        fontSize: 12.0),
                  ),
                ),
                new Text(
                  TimeUtils.CalculateTime(commit.created_at),
                  style:
                  new TextStyle(color: Color(0xFF50616D), fontSize: 10.0),
                ),
              ],
            ),
          ],
        ),
        new Container(
          child: new Text(
            commit.body,
            style: new TextStyle(
              color: Color(0xFF000000),
              fontSize: 14.0,
            ),
          ),
          margin: const EdgeInsets.only(left: 60.0, bottom: 2.0),
        ),
        new Container(
          child: new Divider(),
          margin: const EdgeInsets.only(left: 60.0, bottom: 2.0),
        ),
      ],
    );
  }

  Widget getIcon(String url) {
    if (url.contains('null')) {
      return new Image.asset(
        "images/shutter.png",
        fit: BoxFit.fitWidth,
        width: 36.0,
        height: 36.0,
      );
    } else {
      return new FadeInImage.assetNetwork(
        placeholder: "images/shutter.png",
        //预览图
        fit: BoxFit.fitWidth,
        image: Constant.baseUrl + url,
        width: 36.0,
        height: 36.0,
      );
    }
  }

  Future<Null> _refreshData() {
    final Completer<Null> completer = new Completer<Null>();

    curPageNum = 1;
    if (Indicator_index == 1) {
      _presenter.loadDots(curPageNum, micropost.id);
    } else {
      _presenter.loadCommit(curPageNum, micropost.id);
    }

    setState(() {});

    completer.complete(null);

    return completer.future;
  }
  @override
  jumpToDetail(Micropost item) {}

  @override
  tap_dot(Micropost item) {}

  @override
  goPhotoView(String url) {}

  @override
  void updateSingleFeed(Micropost m) {}

  @override
  void onloadFLFail() {}

  @override
  void onloadFLSuc(List<Commit> list) {
    if (curPageNum == 1) {
      commitDatas.clear();
    }
    setState(() {
      commitDatas.addAll(list);
    });
  }


  @override
  void onloadDotSuc(List<Dot> list) {
    if (curPageNum == 1) {
      dotDatas.clear();
    }
    setState(() {
      dotDatas.addAll(list);
    });
  }

  @override
  setPresenter(MicropostIPresenter presenter) {
    _presenter = presenter;
  }
}
