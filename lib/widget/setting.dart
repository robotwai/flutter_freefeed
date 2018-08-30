import 'package:flutter/material.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'dart:async';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/widget/common_webview.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingState createState() {
    return new _SettingState();
  }
}

class _SettingState extends State<SettingPage> {
  String token;
  bool _showDialog = false;

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
                    onTap: (){
                      jumpToAboutUs('关于我');
                    },
                  ),
                  new ListTile(
                    title: new Text('意见'),
                    leading: new Icon(Icons.feedback),
                    onTap: (){
                      jumpToAboutUs('提交issues');
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: getBottom()
    );
  }

  void logout() async {
    await CommonSP.saveAccount(null);
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
          title: new Text('确定要退出登录么？', style: new TextStyle(fontSize: 16.0),),

          actions: <Widget>[
            new FlatButton(
              child: new Text(
                '确认退出', style: new TextStyle(color: Color(CLS.TextWarning)),),
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
            ),
            new FlatButton(
              child: new Text(
                '取消', style: new TextStyle(color: Color(CLS.TextLabel)),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  jumpToAboutUs(String title){
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CommonWebView(title, title == '关于我'
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
}
