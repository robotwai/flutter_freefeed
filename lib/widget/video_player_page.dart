import 'package:flutter/material.dart';
import 'package:flutter_app/widget/test.page.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:video_player/video_player.dart';

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
              Constant.baseUrl + widget.video_url,
              Constant.baseUrl + widget.img_url,
                  (BuildContext context, VideoPlayerController controller) =>
                  AspectRatioVideo(controller),
            ),
          ),
        ),
//        onTap: () {
//          Navigator.of(context).pop();
//        },
        onVerticalDragDown: (de) {
          position_y = de.globalPosition.dy;
          print(position_y.toString());
        },
        onVerticalDragUpdate: (de) {
          if (de.globalPosition.dy - position_y > 40.0) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}