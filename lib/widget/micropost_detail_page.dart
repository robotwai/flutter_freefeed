import 'package:flutter/material.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/utils/time_utils.dart';
import 'package:flutter_app/widget/micropost_common_page.dart';

class MicropostDetailPage extends StatefulWidget {
  Micropost micropost;

  @override
  _MicropostDetailState createState() {
    return new _MicropostDetailState(micropost);
  }

  MicropostDetailPage(this.micropost);

}

class _MicropostDetailState extends State<MicropostDetailPage>
    implements PageCallBack {
  Account account;
  Micropost micropost;

  _MicropostDetailState(this.micropost);

  @override
  void initState() {
    CommonSP.getAccount().then((onValue) {
      account = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Container(
          child: new Center(
            child: new ClipOval(
              child: _getTopIcon(),
            ),
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        leading: new IconButton(
          tooltip: 'Previous choice',
          icon: const Icon(Icons.arrow_back),
          color: Color(0xFF000000),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.more_horiz),
            tooltip: 'Next choice',
            color: Color(0xFF000000),
            onPressed: () {
//              _sendMicropost();
            },
          ),
        ],
      ),
      body: new SingleChildScrollView(
          child: new MicropostPage(micropost, this)
      ),
    );
  }

  Widget _getTopIcon() {
    print(micropost.icon);
    if (micropost == null || micropost.icon == null ||
        micropost.icon == 'null') {
      return new Image.asset("images/shutter.png",
        width: 36.0,
        height: 36.0,);
    } else {
      return new FadeInImage.assetNetwork(

        placeholder: "images/shutter.png",
        //预览图
        fit: BoxFit.fitWidth,
        image: Constant.baseUrl + micropost.icon,
        width: 36.0,
        height: 36.0,
      );
    }
  }

  @override
  jumpToDetail(Micropost item) {

  }

  @override
  tap_dot(Micropost item) {

  }

  @override
  goPhotoView(String url) {

  }


}