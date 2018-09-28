import 'package:flutter/material.dart';
import 'package:flutter_app/widget/test.page.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app/utils/file_utils.dart';
import 'package:flutter_app/utils/toast_utils.dart';

class VideoPage extends StatefulWidget {
  String video_url;
  String img_url;


  VideoPage(this.video_url, this.img_url);

  @override
  _VideoPageState createState() {
    return _VideoPageState();
  }


}

class _VideoPageState extends State<VideoPage> {
  double position_y;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new GestureDetector(
        child: new Container(
          child: new Center(
            child: NetworkPlayerLifeCycle(
                widget.video_url,
                widget.img_url,
                  (BuildContext context, VideoPlayerController controller) =>
                  AspectRatioVideo(controller),
                null),
          ),
        ),
        onVerticalDragDown: (de) {
          position_y = de.globalPosition.dy;
          print(position_y.toString());
        },
        onVerticalDragUpdate: (de) {
          if (de.globalPosition.dy - position_y > 40.0) {
            Navigator.of(context).pop();
          }
        },
        onLongPress: () {
          _showBottomItem(widget.video_url);
        },
      ),
    );
  }


  _showBottomItem(String url) {
    showModalBottomSheet<Null>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              height: 121.0,
              child: new Column(
                children: <Widget>[

                  new GestureDetector(
                    child: new Container(
                      child: new Text(
                        '保存到本地',
                        style: new TextStyle(
                            color: Color(CLS.TEXT_3), fontSize: 14.0),
                      ),
                      height: 60.0,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      alignment: Alignment.center,
                      color: Color(0xffffffff),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      SaveFile().saveVideo(url).then((onValue) {
                        if (onValue != null) {
                          ToastUtils.showSuccessToast("保存成功");
                        } else {
                          ToastUtils.showWarnToast("保存失败");
                        }
                      });
                    },
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                    child: new Divider(
                      height: 1.0,
                    ),
                  ),
                  new GestureDetector(
                    child: new Container(
                      child: new Text(
                        '取消',
                        style: new TextStyle(
                            color: Color(CLS.TEXT_3), fontSize: 14.0),
                      ),
                      height: 60.0,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      alignment: Alignment.center,
                      color: Color(0xffffffff),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),

                ],
              ));
        });
  }
}