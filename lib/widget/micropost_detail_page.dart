import 'package:flutter/material.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/utils/time_utils.dart';
import 'package:flutter_app/widget/micropost_common_page.dart';
import 'package:flutter_app/mvp/m_presenter.dart';
import 'package:flutter_app/model/commit_model.dart';
import 'package:flutter_app/mvp/m_presenter_impl.dart';
import 'dart:async';
import 'package:flutter_app/widget/Indicator_line.dart';
import 'package:flutter_app/model/dot_model.dart';
import 'package:flutter_app/widget/user_detail_page.dart';
import 'package:flutter_app/widget/multi_touch_page.dart';

class MicropostDetailPage extends StatefulWidget {
  Micropost micropost;
  _MicropostDetailState myMicropostDetailState;
  @override
  _MicropostDetailState createState() {
    myMicropostDetailState = new _MicropostDetailState(micropost);
    MicropostIPresenter presenter =
        new MicropostPresenterImpl(myMicropostDetailState);
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
    _scrollController = new ScrollController()..addListener(_scrollListener);
    _refreshData();
  }

  int Indicator_index = 1;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext mContext;
  @override
  Widget build(BuildContext context) {
    mContext = context;
    return new WillPopScope(
        child: new Scaffold(
          key: _scaffoldKey,
          appBar: getAppBar(),
          body: getList(),
        ),
        onWillPop: _singleExit);
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
          Navigator.of(context).pop(micropost);
//          Navigator.of(context).pop(micropost);
        },
      ),
      elevation: 0.0,
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
    return new Row(
      children: <Widget>[
        new GestureDetector(
          child: new Container(
            child: new Center(
              child: new Text(
                "赞  " + micropost.dots_num.toString(),
                style: TextStyle(
                    color: Indicator_index == 1
                        ? Color(CLS.INDICATOR)
                        : Color(CLS.TextLabel)),
              ),
            ),
            width: (MediaQuery.of(context).size.width) / 3,
            height: 40.0,
          ),
          onTap: () {
            sw(1);
          },
        ),
        new GestureDetector(
          child: new Container(
            child: new Center(
              child: new Text("评论 " + micropost.comment_num.toString(),
                  style: TextStyle(
                      color: Indicator_index == 2
                          ? Color(CLS.INDICATOR)
                          : Color(CLS.TextLabel))),
            ),
            width: (MediaQuery.of(context).size.width) / 3,
            height: 40.0,
          ),
          onTap: () {
            sw(2);
          },
        ),
        new GestureDetector(
          child: new Container(
            child: new Center(
              child: new Text("转发 " + '',
                  style: TextStyle(
                      color: Indicator_index == 3
                          ? Color(CLS.INDICATOR)
                          : Color(CLS.TextLabel))),
            ),
            width: (MediaQuery.of(context).size.width) / 3,
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

  int sendColor = 0xFF9c9c9c;

  sw(int index) {
    print(index.toString());
    FocusScope.of(context).requestFocus(new FocusNode());
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
    } else if (Indicator_index == 2) {
      datas = commitDatas;
    } else {
      datas = [];
    }
    content = new ListView.builder(
      itemCount: datas.length == 0 ? 2 : datas.length + 1,
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
                  painter: new IndicatorLine(
                      Indicator_index, 3, MediaQuery.of(context).size.width),
                  isComplex: true,
                ),
                width: MediaQuery.of(context).size.width,
                height: 6.0,
              ),
            ],
          );
        } else {
          i -= 1;
          if (datas.length == 0) {
            if (Indicator_index == 1) {
              return new Container(
                color: Color(CLS.BACKGROUND),
                height: 200.0,
                padding: const EdgeInsets.only(top: 80.0),
                child: new Center(
                  child: new Column(
                    children: <Widget>[
                      new Image.asset(
                        "images/blank.png",
                        fit: BoxFit.fitWidth,
                        width: 64.0,
                        height: 64.0,
                      ),
                      new Text("还没有人点赞哦")
                    ],
                  ),
                ),
              );
            } else if (Indicator_index == 2) {
              return new Container(
                color: Color(CLS.BACKGROUND),
                height: 200.0,
                padding: const EdgeInsets.only(top: 80.0),
                child: new Center(
                  child: new Column(
                    children: <Widget>[
                      new Image.asset(
                        "images/blank.png",
                        fit: BoxFit.fitWidth,
                        width: 64.0,
                        height: 64.0,
                      ),
                      new Text("发表自己的看法，做第一个评论的人吧！")
                    ],
                  ),
                ),
              );
            } else {
              return new Container(
                color: Color(CLS.BACKGROUND),
                height: 200.0,
                padding: const EdgeInsets.only(top: 80.0),
                child: new Center(
                  child: new Column(
                    children: <Widget>[
                      new Image.asset(
                        "images/blank.png",
                        fit: BoxFit.fitWidth,
                        width: 64.0,
                        height: 64.0,
                      ),
                      new Text("转发功能还未开放哦")
                    ],
                  ),
                ),
              );
            }
          }
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
        child: new Container(
          color: Color(CLS.BACKGROUND),
          child: new GestureDetector(
            child: content,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
          ),
        ));
    return new Column(
      children: <Widget>[
        new Flexible(
          child: _refreshIndicator,
        ),
        new Container(
            color: Color(0xffffff),
            height: 41.0,
            width: MediaQuery.of(context).size.width,
            child: new Column(
              children: <Widget>[
                new Divider(
                  height: 1.0,
                ),
                new Container(
                    height: 40.0,
                    padding: const EdgeInsets.only(left: 14.0),
                    child: new Row(
                      children: <Widget>[
                        new Flexible(
                          child: new TextField(
                            controller: _commentController,
                            autofocus: false,
                            autocorrect: false,

                            maxLines: 1,
                            decoration: new InputDecoration(
                                hintText: '写评论...',
                                hintStyle:
                                    new TextStyle(color: Color(CLS.TextLabel))),
                          ),
                        ),
                        new Container(
                          margin: new EdgeInsets.symmetric(horizontal: 4.0),
                          child: new IconButton(
                              icon: new Icon(Icons.send),
                              onPressed: () {
                                FocusScope.of(context).requestFocus(
                                    new FocusNode());
                                sendCommit(); //modified  当没有为onPressed绑定处理函数时，IconButton默认为禁用状态
                              }),
                        ),
                      ],
                    ))
              ],
            )),
      ],
    );
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
                jumpToUser(dot.user_id);
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
                jumpToUser(commit.user_id);
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
    } else if (Indicator_index == 2) {
      _presenter.loadCommit(curPageNum, micropost.id);
    } else {

    }

    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  Future<bool> checkToLogin() async {
    Account a = await CommonSP.getAccount();
    setState(() {
      account = a;
    });
    if (account == null || account.token == '0') {
      Navigator.of(context).pushNamed('/c').then((value) {
        if (value == 1) {
          print('login success');
          print("getUserInfo");
          getMicropostInfo();
        }
      });
      return false;
    } else {
      return true;
    }
  }

  sendCommit() {
    checkToLogin().then((onValue) {
      if (onValue) _presenter.sendCommit(micropost, _commentController.text);
    });
  }

  getMicropostInfo() {
    _presenter.loadMicropost(micropost.id);
  }

  @override
  jumpToDetail(Micropost item) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  tap_dot(Micropost item) {
    checkToLogin().then((onValue) {
      if (onValue) _presenter.dot(item);
    });
  }

  @override
  jumpToUser(int id) {
    checkToLogin().then((onValue) {
      if (onValue) {
        Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new UserDetailPage(id);
          },
        ));
      }
    });

  }

  @override
  goPhotoView(int type, List<String> list) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new MultiTouchAppPage(list, type);
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
  void updateSingleFeed(Micropost m) {
    setState(() {
      micropost = m;
    });
  }

  @override
  void onloadFLFail() {}

  @override
  void onloadFLSuc(List<Commit> list) {
    if (curPageNum == 1) {
      commitDatas.clear();
    }
    setState(() {
      commitDatas.addAll(list.reversed);
      micropost.comment_num = commitDatas.length;
    });
  }

  @override
  void onloadDotSuc(List<Dot> list) {
    if (curPageNum == 1) {
      dotDatas.clear();
    }
    setState(() {
      dotDatas.addAll(list.reversed);
      micropost.dots_num = dotDatas.length;
    });
  }

  @override
  setPresenter(MicropostIPresenter presenter) {
    _presenter = presenter;
  }

  @override
  void onCommitFail(String f) {}

  @override
  void onCommitSuc() {
    sw(2);
    _commentController.clear();
  }

  Future<bool> _singleExit() {
//    Navigator.of(mContext).pop(micropost);
    Navigator.of(mContext).pop(micropost);
    return new Future.value(false);
  }
}
