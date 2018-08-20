import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/network/common_http_client.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterState createState() {
    return new _RegisterState();
  }
}

class _RegisterState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  String _passwordConfirm;
  String _name;

  @override
  Widget build(BuildContext context) {
    var node = new FocusNode();
    return new Scaffold(
        key: _scaffoldkey,
        appBar: new AppBar(
          title: new Text("Login"),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: new SingleChildScrollView(
          child: new Padding(
            padding: EdgeInsets.all(10.0),
            child: new Form(
                key: formKey,
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      onChanged: (str) {
                        _email = str;
                        print(_email);
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
                    new TextField(
                      onChanged: (text) {
                        _password = text;
                        print(_password);
                      },
                      obscureText: true,
                      maxLines: 1,
                      decoration: new InputDecoration(
                          hintText: '请输入长度大于6的密码',
                          labelText: '密码',
                          labelStyle:
                          new TextStyle(color: Color(CLS.TextLabel))),
                      keyboardType: TextInputType.text,
                      onSubmitted: (text) {},
                    ),
                    new TextField(
                      onChanged: (text) {
                        _passwordConfirm = text;
                        print(_passwordConfirm);
                      },
                      obscureText: true,
                      maxLines: 1,
                      decoration: new InputDecoration(
                          hintText: '请输入长度大于6的密码',
                          labelText: '请再次输入密码',
                          labelStyle:
                          new TextStyle(color: Color(CLS.TextLabel))),
                      keyboardType: TextInputType.text,
                      onSubmitted: (text) {},
                    ),
                    new Container(
                      child: new GestureDetector(
                        child: new Center(
                            child: new ClipOval(
                              child: getIcon(),
                            )),
                        onTap: getImage,
                      ),
                      margin: const EdgeInsets.only(top: 40.0),
                    ),
                    new Container(
                      child: new TextField(
                        onChanged: (str) {
                          _name = str;
                          print(_name);
                        },
                        decoration: new InputDecoration(
                            labelText: '昵称',
                            hintText: '请输入昵称',
                            labelStyle:
                            new TextStyle(color: Color(CLS.TextLabel))),
                        maxLines: 1,
                        onSubmitted: (text) {
                          FocusScope.of(context).reparentIfNeeded(node);
                        },
                      ),
                    )
                  ],
                )),
          ),
        ),
        bottomNavigationBar: new GestureDetector(
          child: new Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.blueAccent,
              height: 48.0,
              child: new Center(
                child: Text(
                  "注册",
                  style: new TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFFFF2DF),
                      fontSize: 16.0),
                ),
              )),
          onTap: onPressed,
        ));
  }

  Widget getIcon() {
    if (icon == null) {
      return new Image.asset(
        "images/shutter.png",
        fit: BoxFit.fitWidth,
        width: 80.0,
        height: 80.0,
      );
    } else {
      return new Image.file(
        new File(icon),
        fit: BoxFit.fitWidth,
        width: 80.0,
        height: 80.0,
      );
    }
  }


  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        print(image.path);
        icon = image.path;
      });
    }
  }

  String icon;

  void onPressed() async {
    if (_password != _passwordConfirm) {
      showToast("请检查密码是否正确");
      return;
    }
    FFHttpUtils.origin.register(_name, _email, _password, icon)
        .then((onValue) {
      if (onValue != null) {
        if (onValue == '0') {
          showToast("注册成功，请到注册邮箱激活账号");
          Navigator.of(context).pop(_email);
        } else {
          showToast(onValue);
        }
      } else {
        showToast('请检查网络');
      }
    });

  }

  void showToast(String text) {
    final snackBar = new SnackBar(content: new Text(text));

    _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}
