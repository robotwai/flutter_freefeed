import 'package:flutter/material.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/utils/time_utils.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MicropostPage extends StatelessWidget {
  Micropost item;
  PageCallBack callBack;
  double system_width;
  int type;

  MicropostPage(this.item, this.callBack, this.type);

  @override
  Widget build(BuildContext context) {
    system_width = MediaQuery
        .of(context)
        .size
        .width;

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Row(
          children: <Widget>[
            new GestureDetector(
              child: new Container(
                child: new ClipOval(
                  child: getIcon(item.icon == null ? "null" : item.icon),
                ),
                margin: const EdgeInsets.all(12.0),
              ),
              onTap: () {
                callBack.jumpToUser(item.user_id);
              },
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    item.user_name,
                    style: new TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF003472),
                        fontSize: 14.0),
                  ),
                ),
                new Text(
                  TimeUtils.CalculateTime(item.created_at),
                  style:
                  new TextStyle(color: Color(0xFF50616D), fontSize: 12.0),
                ),
              ],
            ),
          ],
        ),
        new Container(
          child: new Text(
            item.content,
            style: new TextStyle(
              color: Color(0xFF000000),
              fontSize: 16.0,
            ),
          ),
          margin: const EdgeInsets.all(12.0),
        ),
        new Center(
          child: new Card(
            child: _getImageChild(item.picture),
          ),
        ),
        new Container(
          child: new Divider(
            height: 1.0,
            color: Color(0xFFe0e0e0),
          ),
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        ),
        _getBottomView(item),
      ],
    );
  }

  _getImageChild(String url) {
    if (url != null && url.length > 0) {
      url = url.substring(0, url.length - 1);
    }
    if (url.isEmpty) {
      return new Container();
    } else {
      List<String> list = url.split(',');
      if (list.length == 1) {
        return new GestureDetector(
            onTap: () {
              callBack.goPhotoView(0, list);
            },
            child: new ConstrainedBox(
              child: new CachedNetworkImage(
                placeholder: new CircularProgressIndicator(),
                imageUrl: Constant.baseUrl + list[0],
              ),
              constraints: new BoxConstraints(
                  maxHeight: (system_width - 20) / 2),
            ));
      } else {
        return new Container(
          child: GridView.builder(
            gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: (system_width) / 3,
              mainAxisSpacing: 6.0,
            ),

            itemBuilder: (context, i) {
              return _buildImageRow(i, list);
            },
            physics: new NeverScrollableScrollPhysics(),
            itemCount: list.length,
          ),
          height: calculateHeight(list.length),
          width: system_width - 20.0,
        );
      }
    }
  }

  _buildImageRow(int position, List<String> l) {
    return new GestureDetector(
      onTap: () {
        callBack.goPhotoView(position, l);
      },
      child: new CachedNetworkImage(
        placeholder: new CircularProgressIndicator(),
        imageUrl: Constant.baseUrl + l[position],
      ),
    );
  }

  double calculateHeight(int num) {
    double width = system_width - 20.0;
    double height;
    if (num < 4) {
      height = width / 3;
    } else if (num > 3 && num < 7) {
      height = width / 3 * 2;
    } else {
      height = width;
    }

    return height;
  }

  Widget getIcon(String url) {
    if (url.contains('null') || url == Constant.baseUrl) {
      return new Image.asset(
        "images/shutter.png",
        fit: BoxFit.fitWidth,
        width: 60.0,
        height: 60.0,
      );
    } else {
      return new CachedNetworkImage(
        //预览图
        fit: BoxFit.fitWidth,
        imageUrl: Constant.baseUrl + url,
        width: 60.0,
        height: 60.0,
      );
    }
  }

  _getBottomView(Micropost item) {
    double size = 20.0;
    bool yizan = item.dotId > 0;
    String zanNum = item.dots_num.toString();
    String commitNum = item.comment_num.toString();
    String zhuanfaNum = '0';
    if (type == 2) {
      zanNum = '';
      commitNum = '';
      zhuanfaNum = '';
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          new GestureDetector(
            child: new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    yizan ? 'images/yizan.png' : 'images/dianzan.png',
                    width: size,
                    height: size,
                  ),
                  new Container(
                    child: new Text(zanNum),
                    margin: const EdgeInsets.only(left: 4.0),
                  )
                ],
              ),
              height: size,
              width: (system_width - 36.0) / 3,
            ),
            onTap: () {
              callBack.tap_dot(item);
            },
          ),
          new Container(
            child: new GestureDetector(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/pinglun.png',
                    width: size,
                    height: size,
                  ),
                  new Container(
                    child: new Text(commitNum),
                    margin: const EdgeInsets.only(left: 4.0),
                  )
                ],
              ),
              onTap: () {
                callBack.jumpToDetail(item);
              },
            ),
            height: size,
            width: (system_width - 36.0) / 3,
          ),
          new Container(
            child: new GestureDetector(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/zhuanfa.png',
                    width: size,
                    height: size,
                  ),
                  new Container(
                    child: new Text(zhuanfaNum),
                    margin: const EdgeInsets.only(left: 4.0),
                  )
                ],
              ),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "转发功能尚未开放哦",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    bgcolor: "#1B9E85",
                    textcolor: '#ffffff');
              },
            ),
            height: size,
            width: (system_width - 36.0) / 3,
          ),
        ],
      ),
    );
  }
}

abstract class PageCallBack {
  tap_dot(Micropost item);

  jumpToDetail(Micropost item);

  goPhotoView(int position, List<String> list);

  jumpToUser(int id);
}
