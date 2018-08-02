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


  String _email;
  String _password;
  @override
  Widget build(BuildContext context) {
    var node = new FocusNode();
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
              new TextField(
                onChanged: (str) {
                  _email = str;
                  print(_email);
                },
                decoration: new InputDecoration(
                  labelText: '用户名',
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
                new InputDecoration(hintText: '请输入长度大于6的密码', labelText: '密码'),
                keyboardType: TextInputType.text,
                onSubmitted: (text) {},
              ),
//              TextFormField(
//                autocorrect: false,
//                decoration: new InputDecoration(
//                  hintText: '请输入邮箱',
//                ),
//                maxLines: 1,
//                //键盘展示为号码
//                keyboardType: TextInputType.emailAddress,
//                validator: (str) {
//                  return str.isEmpty?"邮箱不能为空":null;
//                },
//                onSaved: (str) {
//                  _email = str;
//                },
//              ),
//              TextFormField(
//                autocorrect: false,
//                decoration: new InputDecoration(
//                  hintText: '请输入密码',
//                ),
//                maxLines: 1,
//                //键盘展示为号码
//                keyboardType: TextInputType.number,
//                validator: (str) {
//                  return str.isEmpty?"密码不能为空":null;
//                },
//                onSaved: (str) {
//                  _password = str;
//                },
//              ),
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
          Map userMap = JSON.decode(jsonMap['data']);
          Account user = new Account.fromJson(userMap);
          CommonSP.saveAccount(JSON.encode(user));
          print(user.email);
          Navigator.of(context).pop();
        } else {
          print(response.statusCode);
        }
      } catch (exception) {

        print(exception.toString());
      }
    }

  }



}