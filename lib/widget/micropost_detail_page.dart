import 'package:flutter/material.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/utils/time_utils.dart';
import 'package:flutter_app/widget/micropost_common_page.dart';
import 'package:flutter_app/mvp/m_presenter.dart';
import 'package:flutter_app/model/commit_model.dart';

class MicropostDetailPage extends StatefulWidget {
  Micropost micropost;

  @override
  _MicropostDetailState createState() {
    return new _MicropostDetailState(micropost);
  }

  MicropostDetailPage(this.micropost);
}

class _MicropostDetailState extends State<MicropostDetailPage>
    with SingleTickerProviderStateMixin
    implements PageCallBack, MicropostIView {
  Account account;
  Micropost micropost;
  MicropostIPresenter _presenter;
  ScrollController _scrollController;
  _MicropostDetailState(this.micropost);

  bool isShowTitle = false;
  @override
  void initState() {
    CommonSP.getAccount().then((onValue) {
      account = onValue;
    });
    _scrollController = new ScrollController()
      ..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Container(
          child: new Center(
              child: Offstage(
                offstage: !isShowTitle,
                child: new ClipOval(
                  child: _getTopIcon(),
                ),
              )),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        leading: new IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Color(0xFF000000),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.more_horiz),
            color: Color(0xFF000000),
            onPressed: () {
//              _sendMicropost();
            },
          ),
        ],
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          color: const Color(CLS.BACKGROUND),
          child: new Column(children: <Widget>[
            new MicropostPage(micropost, this),
            new Divider(
              height: 10.0,
            ),
            new Row(
              children: <Widget>[
                new Container(
                  child: new Text("点赞"),
                ),
                new Container(
                  child: new Text("点赞"),
                ),
                new Container(
                  child: new Text("点赞"),
                ),
              ],
            ),
          ]),
        ),
        controller: _scrollController,
      ),
    );
  }

  void _scrollListener() {
    //超过该高度则显示头部icon
    if (_scrollController.position.pixels > 80.0) {
      setState(() {
        isShowTitle = true;
      });
    } else {
      setState(() {
        isShowTitle = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  Widget _getTopIcon() {
    print(micropost.icon);
    if (micropost == null ||
        micropost.icon == null ||
        micropost.icon == 'null') {
      return new Image.asset(
        "images/shutter.png",
        width: 36.0,
        height: 36.0,
      );
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
  jumpToDetail(Micropost item) {}

  @override
  tap_dot(Micropost item) {}

  @override
  goPhotoView(String url) {}

  @override
  void updateSingleFeed(Micropost m) {}

  @override
  void onloadFLFail() {}

  @override
  void onloadFLSuc(List<Commit> list) {}

  @override
  setPresenter(MicropostIPresenter presenter) {
    _presenter = presenter;
  }
}
