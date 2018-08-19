import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constant.dart';
import 'dart:async';
import 'package:flutter_app/model/commit_model.dart';
import 'package:flutter_app/model/dot_model.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/mvp/u_presenter.dart';
import 'package:flutter_app/mvp/u_presenter_impl.dart';
import 'package:flutter_app/widget/micropost_common_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/widget/multi_touch_page.dart';
import 'package:flutter_app/widget/micropost_detail_page.dart';
import 'package:flutter_app/utils/db_helper.dart';
import 'package:flutter_app/widget/user_list_page.dart';
import 'package:flutter_app/widget/user_setting_page.dart';

class UserDetailPage extends StatefulWidget {
  int id;

  UserDetailPage(this.id);

  @override
  _UserDetailPageState createState() {
    _UserDetailPageState _userDetailPageState = new _UserDetailPageState();
    UserIPresenter presenter = new UserPresenterImpl(_userDetailPageState);
    presenter.init();
    return _userDetailPageState;
  }
}

class _UserDetailPageState extends State<UserDetailPage>
    with UserIView, TickerProviderStateMixin, PageCallBack {
  int barTextColor = 0x00ffffff;
  int barBackgroundColor = 0xffBF242A;

  ScrollController _scrollController;
  UserIPresenter _presenter;
  User _user;
  double icon_alpha = 1.0;
  List<Micropost> datas = [];
  int currentPage = 1;
  bool isFullLoad = false;
  int my_id;
  @override
  void initState() {
    super.initState();
    int titlebar = widget.id % 3;
    print('titlecolor' + '$titlebar');
    setState(() {
      switch (titlebar) {
        case 0:
          barBackgroundColor = CLS.TITLE_BLUE;
          break;
        case 1:
          barBackgroundColor = CLS.TITLE_ZISE;
          break;
        case 2:
          barBackgroundColor = CLS.TITLE_RED;
          break;
      }
    });
    CommonSP.getAccount().then((onValue) {
      setState(() {
        my_id = onValue.id;
      });
    });
    _presenter.loadUser(widget.id);
    _presenter.loadMicroposts(widget.id, currentPage);
    _scrollController = new ScrollController()
      ..addListener(_scrollListener);
  }

  void _scrollListener() {
    //超过该高度则显示头部icon
    if (_scrollController.position.pixels > 40.0) {
      setState(() {
        barTextColor = 0xffffffff;
      });
    } else {
      setState(() {
        barTextColor = 0x00ffffff;
      });
    }
    //头像透明度变化
    if (_scrollController.position.pixels < 140.0 &&
        _scrollController.position.pixels > 0.0) {
      setState(() {
        icon_alpha = (140.0 - _scrollController.position.pixels) / 140.0;
      });
    }

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
    return new Scaffold(
      appBar: new AppBar(
        title: new Container(
          child: new Text(
            _user == null ? '' : _user.name,
            style: new TextStyle(color: Color(barTextColor)),
          ),
          color: Color(barBackgroundColor),
        ),
        leading: new IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Color(0xFFFFFFFF),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.more_horiz),
            color: Color(0xFFFFFFFF),
            onPressed: () {},
          ),
        ],
        backgroundColor: Color(barBackgroundColor),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: getList(),
    );
  }

  getList() {
    var content;

    content = new ListView.builder(
      addRepaintBoundaries: false,
      itemCount: datas.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return _getListHeader();
        } else {
          i -= 1;
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

  Widget _getListHeader() {
    return new Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new Container(
              color: Color(barBackgroundColor),
              height: 100.0,
            ),
            new Container(
              padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
              color: Color(CLS.BACKGROUND),
              height: 220.0,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(
                        bottom: 14.0, left: 14.0, top: 40.0),
                    child: new Text(
                      _user == null ? '' : _user.name,
                      style: new TextStyle(
                          color: Color(CLS.TEXT_0),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 14.0, left: 14.0),
                    child: new Text(
                      _user == null || _user.sign_content == null ? '' : _user
                          .sign_content,
                      style: new TextStyle(
                          color: Color(CLS.TEXT_3),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 14.0, bottom: 14.0),
                    child: new Row(
                      children: <Widget>[
                        new GestureDetector(
                          child: new Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: new Row(
                                children: <Widget>[
                                  new Text(
                                    _user == null
                                        ? ''
                                        : _user.followed == 0
                                        ? '暂无'
                                        : _user.followed.toString() + '  ',
                                    style: new TextStyle(
                                        color: Color(CLS.TEXT_0),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  new Text(
                                    '关注',
                                    style: new TextStyle(
                                        color: Color(CLS.TEXT_6),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              )),
                          onTap: () {
                            Navigator.of(context).push(new PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) {
                                return new UserListPage(widget.id, 1);
                              },
                            ));
                          },
                        ),
                        new GestureDetector(
                          child: new Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: new Row(
                                children: <Widget>[
                                  new Text(
                                    _user == null
                                        ? ''
                                        : _user.follower == 0
                                        ? '暂无'
                                        : _user.follower.toString() + '  ',
                                    style: new TextStyle(
                                        color: Color(CLS.TEXT_0),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  new Text(
                                    '关注者',
                                    style: new TextStyle(
                                        color: Color(CLS.TEXT_6),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              )),
                          onTap: () {
                            Navigator.of(context).push(new PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) {
                                return new UserListPage(widget.id, 2);
                              },
                            ));
                          },
                        ),
                        new Text(
                          'Ta的赞',
                          style: new TextStyle(
                              color: Color(CLS.TEXT_6),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                  new Container(
                      height: 30.0,
                      color: Color(0xFFECEDF0),
                      padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                      child: new Row(
                        children: <Widget>[
                          new Flexible(
                            fit: FlexFit.tight,
                            child: new Text(
                                "推文 " +
                                    (_user == null
                                        ? ''
                                        : _user.micropost_num.toString()),
                                style: new TextStyle(
                                    color: Color(CLS.TEXT_6),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300)),
                          ),
                          new Text("筛选",
                              style: new TextStyle(
                                  color: Color(CLS.TEXT_6),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300)),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
        new Container(
          child: new Row(
            children: <Widget>[
              new Container(
                width: 80.0,
                child: new Opacity(
                  opacity: icon_alpha,
                  child: new ClipOval(
                    child: getLeftIcon(),
                  ),
                ),
              ),
              new Expanded(child: new Container()),
              getFollowButton(),
            ],
          ),
          margin: const EdgeInsets.only(top: 60.0, left: 14.0),
        ),
      ],
    );
  }

  Widget getLeftIcon() {
    if (_user == null || _user.icon == null) {
      return new Image.asset(
        "images/shutter.png",
        fit: BoxFit.fitWidth,
        width: 80.0,
        height: 80.0,
      );
    } else {
      return new FadeInImage.assetNetwork(
        placeholder: "images/shutter.png",
        //预览图
        fit: BoxFit.fitWidth,
        image: Constant.baseUrl + _user.icon,
        width: 80.0,
        height: 80.0,
      );
    }
  }

  Widget getFollowButton() {
    return new Container(
      child: new Material(
        borderRadius: BorderRadius.circular(20.0),
        child: new RaisedButton(
          onPressed: () {
            if (my_id == widget.id) {
              jumpToUserSet();
            } else {
              if (_user == null || _user.relation == 0 || _user.relation == 1) {
                _presenter.follow(widget.id, 1);
              } else {
                _presenter.follow(widget.id, 2);
              }
            }

          },
          child: new Text(
              my_id == widget.id
                  ? '编辑个人资料' : _user == null || _user.relation == 0 ||
                  _user.relation == 1
                  ? '关注'
                  : _user.relation == 3 ? '互相关注' : '已关注',
              style: new TextStyle(fontSize: 14.0, color: Color(0xffffffff)),
              maxLines: 1),
          color: Color(my_id == 0
              ? 0xffffffff
              : barBackgroundColor),
          elevation: 0.0,
        ),
      ),
      margin: const EdgeInsets.only(top: 40.0, left: 14.0, right: 14.0),
    );
  }

  Future<Null> _refreshData() {
    final Completer<Null> completer = new Completer<Null>();
    currentPage = 1;
    _presenter.loadUser(widget.id);
    _presenter.loadMicroposts(widget.id, currentPage);
    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  Future<Null> _loadData() {
    final Completer<Null> completer = new Completer<Null>();

    currentPage = currentPage + 1;

    _presenter.loadMicroposts(widget.id, currentPage);

    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  @override
  void updateSingleFeed(Micropost m) {
    List<Micropost> l = [];
    print(m.id.toString());
    l.add(m);
    setState(() {});
    addAndRemoveDuplicate(l);
  }

  @override
  void onLoadFail() {}

  @override
  setPresenter(UserIPresenter presenter) {
    _presenter = presenter;
  }

  @override
  void onLoadUserSuc(User user) {
    if (user.id == my_id) {
      CommonSP.getAccount().then((onValue) {
        Account a = onValue;
        a.name = user.name;
        a.followed = user.followed;
        a.follower = user.follower;
        a.sign_content = user.sign_content;
        a.icon = user.icon;
        CommonSP.saveAccount(a);
      });
    }
    setState(() {
      _user = user;
    });
  }

  @override
  void onLoadDotSuc(List<Dot> list) {}

  @override
  void onLoadCoSuc(List<Commit> list) {}

  @override
  void onLoadMicropostSuc(List<Micropost> list) {
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
  jumpToUser(int item) {}

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

  jumpToUserSet() {
    Navigator
        .of(context)
        .push(new PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return new UserSettingPage();
      },
    ));
  }

  @override
  jumpToDetail(Micropost item) {
    print('jumpToDetail');
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
    print(m);
    updateSingleFeed(m);
  }

  @override
  tap_dot(Micropost item) {
    _presenter.dot(item);
  }

  @override
  void onFollowSuc(int type) {
    if (type == 1) {
      setState(() {
        _user.follower++;
        _user.relation = _user.relation + 2;
        print(_user.relation.toString());
      });
    } else {
      setState(() {
        _user.follower--;
        _user.relation = _user.relation - 2;
        print(_user.relation.toString());
      });
    }
  }
}
