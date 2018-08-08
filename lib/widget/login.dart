import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter/cupertino.dart';

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
          default_email = onValue;
        });
      }
    });
  }

  void onPressed() async {
    var form = formKey.currentState;
    var httpClient = new HttpClient();
    if (form.validate()) {
      form.save();

      print('phone: $_email');
      print('phone: $_password');

      try {
        setState(() {
          isLoading = true;
        });

        var uri = new Uri.http(Constant.baseUrlNoHttp, '/app/loggin',
            {'email': '$_email', 'password': '$_password'});
        await new Future.delayed(const Duration(seconds: 4), () {
          //任务具体代码
          print('1');
        });
        var request = await httpClient.postUrl(uri);
        var response = await request.close();
        if (response.statusCode == HttpStatus.OK) {
          var json = await response.transform(UTF8.decoder).join();
          print(json);
          Map jsonMap = JSON.decode(json);
          print(jsonMap['data']);
          if (int.parse(jsonMap['status']) != Constant.HTTP_OK) {
            setState(() {
              showToast();
              isLoading = false;
            });
          } else {
            Map userMap = JSON.decode(jsonMap['data']);
            Account user = new Account.fromJson(userMap);
            await CommonSP.saveAccount(JSON.encode(user));

            print(user.email);
            CommonSP.saveEmail(user.email);
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop(1);
          }
        } else {
          print(response.statusCode);
        }
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

  void showToast() {
    final snackBar = new SnackBar(content: new Text('账号/密码错误'));

    _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}
