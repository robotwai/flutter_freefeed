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

  final TextEditingController _commentController = new TextEditingController();

  bool isShowTitle = false;
  @override
  void initState() {
    CommonSP.getAccount().then((onValue) {
      account = onValue;
    });
    dots_num = micropost.dots_num;
    comment_num = micropost.comment_num;
    zf_num = 123;
    _scrollController = new ScrollController()
      ..addListener(_scrollListener);
    _refreshData();

    new Future.delayed(const Duration(microseconds: 300), () {
      //任务具体代码
      _persistentBottomSheet();
    });
  }


  int Indicator_index = 1;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext mContext;
  @override
  Widget build(BuildContext context) {
    mContext = context;
    return new WillPopScope(child: new Scaffold(
      key: _scaffoldKey,
      appBar: getAppBar(),
      body: getList(),

    ), onWillPop: _singleExit);
  }

  Future<bool> _singleExit() {
    Navigator.of(mContext).pop();
    return new Future.value(true);
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

  int dots_num;
  int comment_num;
  int zf_num;
  Widget getTabs() {
    int a = micropost.dots_num;
    int b = micropost.comment_num;
    int c = 123;
    return new Row(
      children: <Widget>[
        new GestureDetector(
          child: new Container(
            child: new Center(
              child: new Text("赞  " + '$dots_num',
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
              child: new Text("评论 " + '$comment_num',
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
              child: new Text("转发 " + '$zf_num',
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

  void _persistentBottomSheet() {
    _scaffoldKey.currentState.showBottomSheet((context) {
      return new Container(
        color: Color(CLS.HALF_BACKGROUND),
        height: 40.0,
        child: new Center(
          child: new TextField(
            controller: _commentController,
            autofocus: false,
            maxLines: 1,
            decoration: new InputDecoration(
                hintText: '写评论...',

                hintStyle:
                new TextStyle(color: Color(CLS.TextLabel))),
            onSubmitted: (text) {
              _presenter.sendCommit(micropost.id, text);
            },
          ),
        ),
      );
    });
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
              new Container(
                child: new MicropostPage(micropost, this, 2),
                margin: const EdgeInsets.all(10.0),
              ),

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
      comment_num = commitDatas.length;
    });
  }


  @override
  void onloadDotSuc(List<Dot> list) {
    if (curPageNum == 1) {
      dotDatas.clear();
    }
    setState(() {
      dotDatas.addAll(list);
      dots_num = dotDatas.length;
    });
  }

  @override
  setPresenter(MicropostIPresenter presenter) {
    _presenter = presenter;
  }

  @override
  void onCommitFail(String f) {

  }

  @override
  void onCommitSuc() {
    sw(2);
    _commentController.text = '';
  }

}
