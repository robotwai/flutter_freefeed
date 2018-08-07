import 'package:flutter/material.dart';
import 'package:flutter_app/utils/sp_local.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingState createState() {
    return new _SettingState();
  }
}

class _SettingState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text('设置'),
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new ListTile(
                title: new Text('关于我们'),
                leading: new Icon(Icons.more),
              ),
              new ListTile(
                title: new Text('意见'),
                leading: new Icon(Icons.feedback),
              ),
            ],
          ),
        ),
        bottomNavigationBar: new GestureDetector(
          child: new Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Color(0xffFF461F),
              height: 40.0,
              child: new Center(
                child: Text(
                  "退出登录",
                  style: new TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFFFF2DF),
                      fontSize: 16.0),
                ),
              )),
          onTap: logout,
        )
    );
  }

  void logout() async {
    await CommonSP.saveAccount("");
    setState(() {
      Navigator.of(context).pop(1);
    });
  }
}
