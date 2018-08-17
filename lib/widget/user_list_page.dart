import 'package:flutter/material.dart';
import 'package:flutter_app/model/user_model.dart';
import 'dart:async';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/network/common_http_client.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/widget/user_detail_page.dart';

class UserListPage extends StatefulWidget {
  int id;
  int type;

  UserListPage(this.id, this.type);

  @override
  _UserListPageState createState() {
    return new _UserListPageState();
  }
}

class _UserListPageState extends State<UserListPage> {
  List<User> datas = [];
  int curPageNum = 1;
  int my_id = 0;
  ScrollController _scrollController;
  bool isFullLoad = false;

  @override
  void initState() {
    CommonSP.getAccount().then((onValue) {
      setState(() {
        my_id = onValue.id;
      });
    });
    _refreshData();
    _scrollController = new ScrollController()
      ..addListener(_scrollListener);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.type == 1 ? '正在关注' : '关注者',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    var content;

    if (datas.isEmpty) {
      content = new Center(child: new CircularProgressIndicator());
    } else {
      content = new ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: datas.length,
        itemBuilder: _buildRow,
        controller: _scrollController,
      );
    }

    var _refreshIndicator = new Container(
      child: new RefreshIndicator(
        onRefresh: _refreshData,
        child: content,
      ),
      margin: const EdgeInsets.only(top: 10.0),
      color: const Color(0xffffffff),
    );

    return _refreshIndicator;
  }

  Widget _buildRow(BuildContext context, int index) {
    User user = datas[index];
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Row(
          children: <Widget>[
            new GestureDetector(
              child: new Container(
                child: new ClipOval(
                  child: getIcon(user.icon == null ? "null" : user.icon),
                ),
                margin: const EdgeInsets.all(12.0),
              ),
              onTap: () {
                Navigator.of(context).push(new PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return new UserDetailPage(user.id);
                  },
                ));
              },
            ),
            new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: new Text(
                      user.name,
                      style: new TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF003472),
                          fontSize: 16.0),
                    ),
                  ),
                  new Text(
                    user.sign_content,
                    style:
                    new TextStyle(color: Color(0xFF50616D), fontSize: 12.0),
                  ),
                ],
              ),
            ),
            getFollowButton(index, user),
          ],
        ),
        new Container(
          child: new Divider(),
        ),
      ],
    );
  }

  int barBackgroundColor = CLS.TITLE_BLUE;

  Widget getFollowButton(int index, User _user) {
    return new Container(
      child: new Material(
        borderRadius: BorderRadius.circular(20.0),
        child: new RaisedButton(
          onPressed: () {
            if (_user == null || _user.relation == 0 || _user.relation == 1) {
//              _presenter.follow(widget.id, 1);
              follow(index, _user.id, 1);
            } else {
              follow(index, _user.id, 2);
//              _presenter.follow(widget.id, 2);
            }
          },
          child: new Text(
              _user == null || _user.relation == 0 || _user.relation == 1
                  ? '关注'
                  : _user.relation == 3 ? '互相关注' : '已关注',
              style: new TextStyle(fontSize: 12.0, color: Color(0xffffffff)),
              maxLines: 1),
          color: Color(my_id == 0 || my_id == _user.id
              ? 0xffffffff
              : barBackgroundColor),
          elevation: 0.0,
        ),
      ),
      width: 100.0,
      height: 30.0,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      margin: const EdgeInsets.only(left: 30.0, right: 14.0),
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
    print('_refreshData');
    final Completer<Null> completer = new Completer<Null>();

    curPageNum = 1;
    FFHttpUtils.origin
        .getUserFollower(widget.id, curPageNum, widget.type)
        .then((onValue) {
      datas.clear();
      if (onValue != null && onValue.length > 0) {
        setState(() {
          datas.addAll(onValue);
        });
      }
    });
//    _presenter.loadAIData(token, curPageNum, 1);
    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  Future<Null> _loadData() {
    final Completer<Null> completer = new Completer<Null>();

    curPageNum = curPageNum + 1;

    FFHttpUtils.origin
        .getUserFollower(widget.id, curPageNum, widget.type)
        .then((onValue) {
      if (onValue != null && onValue.length > 0) {
        if (onValue.length < 30) {
          isFullLoad = true;
        } else {
          isFullLoad = false;
        }
        setState(() {
          datas.addAll(onValue);
        });
      }
    });

    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  follow(int index, int id, int type) {
    FFHttpUtils.origin.follow(id, type).then((onValue) {
      if (onValue == '0') {
        if (type == 1) {
          setState(() {
            int a = datas[index].relation;
            datas[index].relation = a + 2;
          });
        } else {
          setState(() {
            int a = datas[index].relation;
            datas[index].relation = a - 2;
          });
        }
      } else {
        print('error');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }
}
