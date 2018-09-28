import 'package:flutter/material.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/utils/time_utils.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/widget/video_player_page.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_app/widget/multi_touch_page.dart';
import 'package:flutter_app/widget/user_detail_page.dart';

class MicropostPage extends StatelessWidget {
  Micropost item;
  PageCallBack callBack;
  double system_width;
  int type;
  bool isHaveVideo = false;

  MicropostPage(this.item, this.callBack, this.type);

  @override
  Widget build(BuildContext context) {
    system_width = MediaQuery
        .of(context)
        .size
        .width;
    isHaveVideo = item.video != null && item.video != "null";
    timeDilation = 1.0; // 1.0 means normal animation speed.
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
                jumpToUser(item.user_id, context);
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
            child: isHaveVideo
                ? _getVideo(item.video_pre, item.video, context)
                : _getImageChild(item.picture, context),
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

  _getVideo(String pic_url, String video_url, BuildContext c) {
    return new GestureDetector(
      onTap: () {
//        callBack.goVideoView(video_url, pic_url);

        Navigator.of(c).push(MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new VideoPage(
                  Constant.baseUrl + video_url, Constant.baseUrl + pic_url);
            }
        ));
      },
      child: new ConstrainedBox(
        child: new Stack(
          children: <Widget>[
            new Center(
              child: new Hero(tag: pic_url, child: new CachedNetworkImage(
                placeholder: new CircularProgressIndicator(),
                imageUrl: Constant.baseUrl + pic_url,
              )),
            ),
            new Align(
              alignment: Alignment.center,
              child: new ClipRRect(
                borderRadius:
                const BorderRadius.all(const Radius.circular(90.0)),
                child: new Container(
                  child: new Container(
                    child: new Icon(
                      Icons.play_arrow, color: Color(0xa0ffffff),),
                    height: 30.0,
                    width: 30.0,

                  ),
                  width: 50.0,
                  height: 50.0,
                  color: const Color(0x60000000),
                ),
              ),
            ),

          ],
        ),
        constraints: new BoxConstraints(maxHeight: (system_width - 20) / 2),
      ),
    );
  }

  _getImageChild(String url, BuildContext c) {
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
//              callBack.goPhotoView(0, list);

              Navigator.of(c).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new MultiTouchAppPage(list, 0);
                  }
              ));
            },
            child: Hero(tag: list[0], child: new ConstrainedBox(
              child: new CachedNetworkImage(
                placeholder: new CircularProgressIndicator(),
                imageUrl: Constant.baseUrl + list[0],
              ),
              constraints:
              new BoxConstraints(maxHeight: (system_width - 20) / 2),
            )));
      } else {
        return new Container(
          child: GridView.builder(
            gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: (system_width) / 3,
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0),
            itemBuilder: (context, i) {
              return _buildImageRow(i, list, context);
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

  _buildImageRow(int position, List<String> l, BuildContext c) {
    return new GestureDetector(
      onTap: () {
//        callBack.goPhotoView(position, l);
        Navigator.of(c).push(MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new MultiTouchAppPage(l, position);
            }
        ));
      },
      child: Hero(tag: l[position], child: new CachedNetworkImage(
        placeholder: new CircularProgressIndicator(),
        imageUrl: Constant.baseUrl + l[position],
      )),
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


  jumpToUser(int id, BuildContext context) {
    if (type != 3) {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new UserDetailPage(id);
          }
      ));
    }
  }
}

abstract class PageCallBack {
  tap_dot(Micropost item);

  jumpToDetail(Micropost item);

}
