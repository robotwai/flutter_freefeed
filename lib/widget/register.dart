import 'package:flutter_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constant.dart';
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
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(CLS.BACKGROUND),
        title: new Image.asset(
          "images/icon_transparent.png",
          fit: BoxFit.fitWidth,
          width: 36.0,
          height: 36.0,
        ),
        leading: new GestureDetector(
          child: new Center(
            child: new Text(
              '取消',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Color(CLS.BASE_COLOR)),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: new SingleChildScrollView(
        child: new Container(
          padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                "创建你的账号",
                style: new TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Color(CLS.TEXT_0)),
              ),
              new Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2 - 160.0,
                ),
                child: new TextField(
                  onChanged: (str) {
                    _name = str;
                    _onTextChange();
                  },
                  decoration: new InputDecoration(
                    hintText: '名字',
                    border: UnderlineInputBorder(borderSide: BorderSide(width: 1.0)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1.0,color: Color(CLS.BASE_COLOR))),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  onSubmitted: (text) {
                    FocusScope.of(context).reparentIfNeeded(node);
                  },
                ),
              ),
              new Padding(
                child: new TextField(
                  onChanged: (str) {
                    _email = str;
                    _onTextChange();
                  },
                  decoration: new InputDecoration(
                      hintText: '电子邮箱地址',
                  border: UnderlineInputBorder(borderSide: BorderSide(width: 1.0)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1.0,color: Color(CLS.BASE_COLOR))),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  onSubmitted: (text) {
                    FocusScope.of(context).reparentIfNeeded(node);
                  },
                ),
                padding: const EdgeInsets.only(top: 14.0,bottom: 14.0),
              ),
              new TextField(
                onChanged: (text) {
                  _password = text;
                  _onTextChange();
                },
                obscureText: true,
                maxLines: 1,
                decoration: new InputDecoration(
                    hintText: '请输入长度大于6的密码',
                  border: UnderlineInputBorder(borderSide: BorderSide(width: 1.0)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1.0,color: Color(CLS.BASE_COLOR))),
                ),
                keyboardType: TextInputType.text,
                onSubmitted: (text) {
                  FocusScope.of(context).reparentIfNeeded(node);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: new Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        color: Colors.white,
        height: 48.0,
        alignment: Alignment.centerRight,
        child: new Container(
          margin: const EdgeInsets.only(right: 14.0),
          child: new Material(
            borderRadius: BorderRadius.circular(24.0),
            child: new RaisedButton(
              onPressed: () {
                onPressed();
              },
              child: new Text('注册',
                  style: new TextStyle(fontSize: 14.0, color: Colors.white),
                  maxLines: 1),
              color: Color(sendColor),
              elevation: 0.0,
            ),
          ),
          height: 40.0,
          width: 90.0,
        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }

  void onPressed() async {
    FFHttpUtils.origin.register(_name, _email, _password, null).then((onValue) {
      if (onValue != null) {
        if (onValue == '0') {
          ToastUtils.showSuccessToast("注册成功");
          Navigator.of(context).pop(_email);
        } else {
          ToastUtils.showWarnToast(onValue);
        }
      } else {
        ToastUtils.showWarnToast('请检查网络');
      }
    });
  }

  int sendColor = 0xA01B9E85;
  void _onTextChange() {
    if(_email!=null&&_email.length>0&&
        _password!=null&&_password.length>0&&
        _name!=null&&_name.length>0){
      setState(() {
        sendColor = 0xFF1B9E85;
      });

    }else{
      setState(() {
        sendColor = 0xA01B9E85;
      });

    }
  }
}
