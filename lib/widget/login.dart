import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/sp_local.dart';
class LoginPage extends StatefulWidget{

  @override
  _LoginState createState() {
    return new _LoginState();
  }
}

class _LoginState extends State<LoginPage>{
  final formKey = GlobalKey<FormState>();


  String _email;
  String _password;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,

      body: new Padding(
        padding: EdgeInsets.all(10.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              TextFormField(
                autocorrect: false,
                decoration: new InputDecoration(
                  hintText: '请输入邮箱',
                ),
                maxLines: 1,
                //键盘展示为号码
                keyboardType: TextInputType.emailAddress,
                validator: (str) {
                  return str.isEmpty?"邮箱不能为空":null;
                },
                onSaved: (str) {
                  _email = str;
                },
              ),
              TextFormField(
                autocorrect: false,
                decoration: new InputDecoration(
                  hintText: '请输入密码',
                ),
                maxLines: 1,
                //键盘展示为号码
                keyboardType: TextInputType.number,
                validator: (str) {
                  return str.isEmpty?"密码不能为空":null;
                },
                onSaved: (str) {
                  _password = str;
                },
              ),
              RaisedButton(
                child: Text( "登陆"),
                onPressed: onPressed,
              ),
            ],
          )),)

    );

  }

  void onPressed() async{
    var form = formKey.currentState;
    var url = 'http://0.0.0./app/loggin';
    var httpClient = new HttpClient();
    String result;
    if (form.validate()) {
      form.save();


      print('phone: $_email');
      print('phone: $_password');

      try {
        var uri = new Uri.http(
            '192.168.45.58:3000', '/app/loggin',
            {'email': '$_email', 'password': '$_password'});
        var request = await httpClient.postUrl(uri);
        var response = await request.close();
        if (response.statusCode == HttpStatus.OK) {
          var json = await response.transform(UTF8.decoder).join();
          print(json);
          Map jsonMap = JSON.decode(json);
          print(jsonMap['data']);
          Map userMap = JSON.decode(jsonMap['data']);
          Account user = new Account.fromJson(userMap);
          CommonSP.saveAccount(JSON.encode(user));
          print(user.email);
          Navigator.of(context).pushNamed('/b');
        } else {
          result =
          'Error getting IP address:\nHttp status ${response.statusCode}';
        }
      } catch (exception) {
        result = 'Failed getting IP address';
      }
    }

  }



}