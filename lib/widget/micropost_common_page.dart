import 'package:flutter/material.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/utils/time_utils.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/widget/multi_touch_page.dart';

class MicropostPage extends StatelessWidget {
  Micropost item;
  PageCallBack callBack;
  double system_width;

  MicropostPage(this.item, this.callBack);

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
                    child: getIcon(Constant.baseUrl + item.icon),
                  ),
                  margin: const EdgeInsets.all(12.0),
                ),
                onTap: () {
                  print("tap");
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
    if (url.isEmpty) {
      return new Container();
    } else {
      List<String> list = url.split(',');
      list.removeAt(list.length - 1);
      if (list.length == 1) {
        return new GestureDetector(
          onTap: () {
            callBack.goPhotoView(Constant.baseUrl + list[0]);
          },
          child: new Image.network(Constant.baseUrl + list[0]),
        );
      } else {
        new Container(
          child: GridView.builder(
            gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150.0),
            itemBuilder: (context, i) {
              return _buildImageRow(list[i]);
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

  _buildImageRow(String url) {
    return new GestureDetector(
      onTap: () {
        callBack.goPhotoView(Constant.baseUrl + url);
      },
      child: Image.network(Constant.baseUrl + url),
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
      return new FadeInImage.assetNetwork(
        placeholder: "images/shutter.png",
        //预览图
        fit: BoxFit.fitWidth,
        image: url,
        width: 60.0,
        height: 60.0,
      );
    }
  }

  _getBottomView(Micropost item) {
    bool yizan = item.dotId > 0;
    int zanNum = item.dots_num;
    int commitNum = item.comment_num;
    int zhuanfaNum = 123;
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
                    width: 15.0,
                    height: 15.0,
                  ),
                  new Container(
                    child: new Text('$zanNum'),
                    margin: const EdgeInsets.only(left: 4.0),
                  )
                ],
              ),
              height: 15.0,
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
                    width: 15.0,
                    height: 15.0,
                  ),
                  new Container(
                    child: new Text('$commitNum'),
                    margin: const EdgeInsets.only(left: 4.0),
                  )
                ],
              ),
              onTap: () {
                callBack.jumpToDetail(item);
              },
            ),
            height: 15.0,
            width: (system_width - 36.0) / 3,
          ),
          new Container(
            child: new GestureDetector(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/zhuanfa.png',
                    width: 15.0,
                    height: 15.0,
                  ),
                  new Container(
                    child: new Text('$zhuanfaNum'),
                    margin: const EdgeInsets.only(left: 4.0),
                  )
                ],
              ),
              onTap: () {
                callBack.tap_dot(item);
              },
            ),
            height: 15.0,
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

  goPhotoView(String url);
}

abstract class controlChildWidget {
  refresh(Micropost i);
}