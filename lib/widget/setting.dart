import 'package:flutter/material.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'dart:async';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/widget/common_webview.dart';
import 'package:flutter_app/utils/db_helper.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingState createState() {
    return new _SettingState();
  }
}

class _SettingState extends State<SettingPage> {
  String token;

  @override
  void initState() {
    super.initState();
    CommonSP.getAccount().then((onValue) {
      if (onValue != null) {
        setState(() {
          token = onValue.token;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text('设置'),
          elevation: 0.0,
          centerTitle: true,
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(top: 10.0),
              color: Color(CLS.BACKGROUND),
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text('关于我'),
                    leading: new Icon(Icons.more),
                    onTap: () {
                      jumpToAboutUs('关于我');
                    },
                  ),
                  new ListTile(
                    title: new Text('意见'),
                    leading: new Icon(Icons.feedback),
                    onTap: () {
                      jumpToAboutUs('提交issues');
                    },
                  ),
                  Offstage(
                    child: new ListTile(
                      title: new Text('注销账号'),
                      leading: new Icon(Icons.remove_circle),
                      onTap: () {
                        _removeAccountFirst();
                      },
                    ),
                    offstage: !(token != null && token != 0),
                  )
                ],
              ),
            ),
          ],
        ),
      bottomNavigationBar: getBottom(),
      resizeToAvoidBottomPadding: true,);
  }

  void logout() async {
    await CommonSP.saveAccount(null);
    MicropostProvider.origin.clearAll();
    setState(() {
      Navigator.of(context).pop(1);
    });
  }

  Widget getBottom() {
    if (token != null && token != 0) {
      return new GestureDetector(
        child: new Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            color: Color(0xffDA4F49),
            height: 44.0,
            child: new Center(
              child: Text(
                "退出登录",
                style: new TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFFFF2DF),
                    fontSize: 16.0),
              ),
            )),
        onTap: _neverSatisfied,
      );
    } else {
      return null;
    }
  }

  Future<Null> _neverSatisfied() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            '确定要退出登录么？',
            style: new TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                '确认退出',
                style: new TextStyle(color: Color(CLS.TextWarning)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
            ),
            new FlatButton(
              child: new Text(
                '取消',
                style: new TextStyle(color: Color(CLS.TextLabel)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _removeAccountFirst() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            '确定要注销账号么？（所有记录都将从服务器消失）',
            style: new TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                '确认注销',
                style: new TextStyle(color: Color(CLS.TextWarning)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _removeAccountSecond();
              },
            ),
            new FlatButton(
              child: new Text(
                '我再想想',
                style: new TextStyle(color: Color(CLS.TextLabel)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _removeAccountSecond() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            '注销账号后所以记录内容都将消失，Email可以再次注册，但原有内容再也无法找回',
            style: new TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                '确认注销',
                style: new TextStyle(color: Color(CLS.TextWarning)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                finalSendPassword();
              },
            ),
            new FlatButton(
              child: new Text(
                '我还要用',
                style: new TextStyle(color: Color(CLS.TextLabel)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  jumpToAboutUs(String title) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CommonWebView(
              title,
              title == '关于我'
                  ? 'https://github.com/robotwai/flutter_freefeed'
                  : 'https://github.com/robotwai/flutter_freefeed/issues');
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new FadeTransition(
              opacity:
              new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        }));
  }

  finalSendPassword() {
    showModalBottomSheet<Null>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              height: 127.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      '正在注销账号，请输入密码',
                      style: new TextStyle(
                          color: Color(CLS.TEXT_9), fontSize: 12.0),
                    ),
                    height: 40.0,
                    alignment: Alignment.center,
                    color: Color(0xffffffff),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                    child: new Divider(
                      height: 1.0,
                    ),
                  ),
                  new Padding(
                    child: new TextField(
                      onChanged: (text) {},
                      obscureText: true,
                      maxLines: 1,
                      decoration: new InputDecoration(
                        hintText: '请输入密码',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                  ),

                  new Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                    child: new Divider(
                      height: 1.0,
                    ),
                  ),
                  new GestureDetector(
                    child: new Container(
                      child: new Text(
                        '确认注销',
                        style: new TextStyle(
                          color: Color(CLS.BACKGROUND), fontSize: 14.0,),
                      ),
                      height: 40.0,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      alignment: Alignment.center,
                      color: Color(CLS.TextWarning),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
        });
  }
}
