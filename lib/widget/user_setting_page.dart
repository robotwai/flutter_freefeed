import 'package:flutter/material.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/network/common_http_client.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class UserSettingPage extends StatefulWidget {
  @override
  _UserSettingPageState createState() {
    return new _UserSettingPageState();
  }
}

class _UserSettingPageState extends State<UserSettingPage> {
  Account account;
  TextEditingController name_c = new TextEditingController();
  TextEditingController sign_c = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  @override
  void initState() {
    CommonSP.getAccount().then((onValue) {
      setState(() {
        account = onValue;
        name_c.text = onValue.name;
        sign_c.text = onValue.sign_content;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
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
            child: new Container(
              child: new Center(
                child: new Text(
                  '完成',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Color(CLS.TEXT_0)),
                ),
              ),
              padding: const EdgeInsets.only(right: 14.0),
            ),
            onTap: () {
              updateUser();
            },
          ),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new SingleChildScrollView(
            child: new Container(
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new Text(
                              '头像',
                              style: new TextStyle(
                                  color: Color(CLS.TEXT_6), fontSize: 16.0),
                            )),
                        new Container(
                          child: new GestureDetector(
                            child: new Container(
                              child: new ClipOval(
                                child: getIcon(
                                    account == null || account.icon == null
                                        ? "null"
                                        : account.icon,icon!=null),
                              ),
                              margin: const EdgeInsets.all(12.0),
                            ),
                            onTap: () {
//                          getImage();
                              _selectIcon();
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
                        new Text(
                          '昵称',
                          style: new TextStyle(
                              color: Color(CLS.TEXT_6), fontSize: 16.0),
                        ),
                        new Flexible(
                            child: new TextField(
                              controller: name_c,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(border: InputBorder.none),
                              style: new TextStyle(
                                  color: Color(CLS.TEXT_6), fontSize: 16.0),
                            )),
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
                              style: new TextStyle(
                                  color: Color(CLS.TEXT_6), fontSize: 16.0),
                            )),
                        new GestureDetector(
                          child: new Text(
                            account == null || account.sex == 0
                                ? "无"
                                : account.sex == 1 ? '男' : '女',
                            style: new TextStyle(
                                color: Color(CLS.TEXT_6), fontSize: 16.0),
                          ),
                          onTap: (){
                            _selectSex();
                          },
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(14.0),
                  ),
                  new Divider(),
                  new Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 14.0),
                    child: new Text(
                      '简介',
                      style:
                      new TextStyle(color: Color(CLS.TEXT_6), fontSize: 16.0),
                    ),
                  ),
                  new Container(
                    child: new TextField(
                      controller: sign_c,
                      decoration: InputDecoration(border: InputBorder.none),
                      style:
                      new TextStyle(color: Color(CLS.TEXT_6), fontSize: 16.0),
                      maxLength: 50,
                      maxLines: 3,
                    ),
                    padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                  )
                ],
              ),
              color: Color(CLS.BACKGROUND),
              margin: const EdgeInsets.only(top: 14.0),
            ),
          ),
          new Offstage(
            child: new Container(
              color: Color(CLS.HALF_BACKGROUND),
              child: new Center(
                child: new CupertinoActivityIndicator(radius: 20.0),),
            ),
            offstage: !isLoading,
          )
        ],
      ),
      resizeToAvoidBottomPadding: true,
    );
  }

  Widget getIcon(String url,bool isForDisk) {
    if(isForDisk){
      return new Image.file(
          new File(url),
        fit: BoxFit.fitWidth,
        width: 64.0,
        height: 64.0,
      );
    }else{
      if (url.contains('null')) {
        return new Image.asset(
          "images/shutter.png",
          fit: BoxFit.fitWidth,
          width: 64.0,
          height: 64.0,
        );
      } else {
        return new FadeInImage.assetNetwork(
          placeholder: "images/shutter.png",
          //预览图
          fit: BoxFit.fitWidth,
          image: Constant.baseUrl + url,
          width: 64.0,
          height: 64.0,
        );
      }
    }

  }

  Future getImage(int type) async {
    var image = await ImagePicker.pickImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      setState(() {
        print(image.path);
        icon = image.path;
        account.icon = icon;
      });
    }
  }

  String icon;

  updateUser() {
    setState(() {
      isLoading = true;
    });
    FFHttpUtils.origin.updateUser(icon, name_c.text, sign_c.text, account.sex)
        .then((onValue){
      setState(() {
        isLoading = false;
      });
        if(onValue!=null&&onValue=='0'){
          Navigator.of(context).pop();
        }else{
          print('please check network');
        }

    });
  }

  _selectIcon() {
    showModalBottomSheet<Null>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              height: 162.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      '替换头像',
                      style: new TextStyle(
                          color: Color(CLS.TEXT_9), fontSize: 12.0),
                    ),
                    height: 40.0,
                    alignment: Alignment.center,
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
                        '拍照',
                        style: new TextStyle(
                            color: Color(CLS.TEXT_3), fontSize: 14.0),
                      ),
                      height: 60.0,
                      alignment: Alignment.center,
                    ),
                    onTap: (){
                      Navigator.of(context).pop();
                      getImage(1);
                    },
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
                        '从相册中选取',
                        style: new TextStyle(
                            color: Color(CLS.TEXT_3), fontSize: 14.0),
                      ),
                      height: 60.0,
                      alignment: Alignment.center,
                    ),
                    onTap: (){
                      Navigator.of(context).pop();
                      getImage(2);
                    },
                  ),
                ],
              ));
        });
  }


  _selectSex() {
    showModalBottomSheet<Null>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              height: 162.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      '性别',
                      style: new TextStyle(
                          color: Color(CLS.TEXT_9), fontSize: 12.0),
                    ),
                    height: 40.0,
                    alignment: Alignment.center,
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
                        '男',
                        style: new TextStyle(
                            color: Color(CLS.TEXT_3), fontSize: 14.0),
                      ),
                      height: 60.0,
                      alignment: Alignment.center,
                    ),
                    onTap: (){
                      Navigator.of(context).pop();
                      setState(() {
                        account.sex = 1;
                      });
                    },
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
                        '女',
                        style: new TextStyle(
                            color: Color(CLS.TEXT_3), fontSize: 14.0),
                      ),
                      height: 60.0,
                      alignment: Alignment.center,
                    ),
                    onTap: (){
                      Navigator.of(context).pop();
                      setState(() {
                        account.sex = 2;
                      });

                    },
                  ),
                ],
              ));
        });
  }
}
