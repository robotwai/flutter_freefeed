import 'package:flutter/material.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/utils/constant.dart';

class UserSettingPage extends StatefulWidget {
  @override
  _UserSettingPageState createState() {
    return new _UserSettingPageState();
  }
}

class _UserSettingPageState extends State<UserSettingPage> {
  Account account;

  @override
  void initState() {
    CommonSP.getAccount().then((onValue) {
      setState(() {
        account = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(CLS.BACKGROUND),
        title: new Text(
          '编辑个人信息',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Color(CLS.TEXT_0)),
        ),
        leading: new GestureDetector(
          child: new Center(
            child: new Text(
              '取消',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Color(CLS.TEXT_0)),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          new GestureDetector(
            child: new Center(
              child: new Text(
                '完成',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Color(CLS.TEXT_0)),
              ),
            ),
            onTap: () {
              print('finish');
            },
          ),
        ],
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new Text(
                    '头像',
                    style:
                        new TextStyle(color: Color(CLS.TEXT_6), fontSize: 16.0),
                  )),
                  new Container(
                    child: new GestureDetector(
                      child: new Container(
                        child: new ClipOval(
                          child: getIcon(account == null || account.icon == null
                              ? "null"
                              : account.icon),
                        ),
                        margin: const EdgeInsets.all(12.0),
                      ),
                      onTap: () {
                        print('ontap');
                      },
                    ),
                  )
                ],
              ),
              padding: const EdgeInsets.all(14.0),
            ),
            new Divider(),
            new Container(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new Text(
                    '昵称',
                    style:
                        new TextStyle(color: Color(CLS.TEXT_6), fontSize: 16.0),
                  )),
                  new Text(
                    account == null || account.name == null
                        ? "null"
                        : account.name,
                    style:
                        new TextStyle(color: Color(CLS.TEXT_6), fontSize: 16.0),
                  )
                ],
              ),
              padding: const EdgeInsets.all(14.0),
            ),
            new Divider(),
            new Container(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new Text(
                    '性别',
                    style:
                        new TextStyle(color: Color(CLS.TEXT_6), fontSize: 16.0),
                  )),
                  new Text(
                    account == null || account.name == null
                        ? "null"
                        : account.name,
                    style:
                        new TextStyle(color: Color(CLS.TEXT_6), fontSize: 16.0),
                  )
                ],
              ),
              padding: const EdgeInsets.all(14.0),
            ),
            new Divider(),
            new Container(
              child: new TextField(
                decoration: new InputDecoration(
                  hintText: '简介',
                  hintStyle:
                      new TextStyle(color: Color(CLS.TEXT_6), fontSize: 16.0),
                ),
              ),
              padding: const EdgeInsets.all(14.0),
            )
          ],
        ),
        color: Color(CLS.BACKGROUND),
        margin: const EdgeInsets.only(top: 14.0),
      ),
    );
  }

  Widget getIcon(String url) {
    if (url.contains('null')) {
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
        image: Constant.baseUrl + url,
        width: 80.0,
        height: 80.0,
      );
    }
  }
}
