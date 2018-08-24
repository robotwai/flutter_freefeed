import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/network/common_http_client.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() {
    return new _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  var _scaffoldkey = new GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String default_email = '';
  bool isLoading = false;
  TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var node = new FocusNode();
    return new Scaffold(
        key: _scaffoldkey,
        appBar: new AppBar(
          title: new Text("登录"),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: new Builder(builder: (BuildContext context) {
          return new Stack(
            children: <Widget>[

              new Padding(
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
                          controller: _controller,
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
                        new Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 30.0, right: 30.0),
                          child: RaisedButton(
                            child: Text("登录"),
                            onPressed: onPressed,
                          ),
                        ),
                        new Container(
                          margin: const EdgeInsets.only(top: 14.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new GestureDetector(
                                child: new Text('注册'),
                                onTap: register,
                              ),
                              new GestureDetector(
                                child: new Text('忘记密码'),
                                onTap: register,
                              )
                            ],
                          ),
                        )
                      ],
                    )),
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
          );
        }));
  }

  void register() {
    Navigator.of(context).pushNamed('/r').then((onValue) {
      if (onValue != null) {
        setState(() {
          _controller.text = onValue;
          _email=onValue;
        });
      }
    });
  }

  void onPressed() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();

      print('phone: $_email');
      print('phone: $_password');

      try {
        setState(() {
          isLoading = true;
        });
        FFHttpUtils.origin.login(_email, _password).then((onValue) {
          if (onValue != null) {
            if (onValue == '0') {
              setState(() {
                isLoading = false;
              });
              Navigator.of(context).pop(1);
            } else {
              setState(() {
                showToast(onValue);
                isLoading = false;
              });
            }
          } else {
            setState(() {
              showToast('请检查网络');
              isLoading = false;
            });
          }
        });

      } catch (exception) {
        print(exception.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    CommonSP.getEmail().then((email) {
      setState(() {
        default_email = email;
      });
    });
  }

  void showToast(String message) {
    final snackBar = new SnackBar(content: new Text(message));

    _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}
