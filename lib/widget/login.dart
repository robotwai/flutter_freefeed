import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/utils/constant.dart';
class LoginPage extends StatefulWidget{

  @override
  _LoginState createState() {
    return new _LoginState();
  }
}

class _LoginState extends State<LoginPage>{
  final formKey = GlobalKey<FormState>();
  var _scaffoldkey = new GlobalKey<ScaffoldState>();

  String _email;
  String _password;
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
          return new Padding(
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
                      ),
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
                      decoration:
                      new InputDecoration(
                          hintText: '请输入长度大于6的密码', labelText: '密码'),
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
                )),);
        })

    );
  }

  void register() {
    Navigator.of(context).pushNamed('/r').then((onValue) {
      if (onValue != null) {
        setState(() {
          _email = onValue;
        });
      }
    });
  }

  void onPressed() async{
    var form = formKey.currentState;
    var httpClient = new HttpClient();
    if (form.validate()) {
      form.save();


      print('phone: $_email');
      print('phone: $_password');

      try {
        var uri = new Uri.http(
            Constant.baseUrlNoHttp, '/app/loggin',
            {'email': '$_email', 'password': '$_password'});
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
            });
          } else {
            Map userMap = JSON.decode(jsonMap['data']);
            Account user = new Account.fromJson(userMap);
            await CommonSP.saveAccount(JSON.encode(user));
            print(user.email);
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

  void showToast() {
    final snackBar = new SnackBar(content: new Text('账号/密码错误'));

    _scaffoldkey.currentState.showSnackBar(snackBar);
  }


}