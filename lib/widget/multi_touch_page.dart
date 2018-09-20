import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/utils/file_utils.dart';
import 'package:flutter_app/utils/toast_utils.dart';

class MultiTouchAppPage extends StatefulWidget {
  List<String> imgUrls;
  int position;

  MultiTouchAppPage(this.imgUrls, this.position);

  @override
  State<StatefulWidget> createState() {
    return new _MultiTouchAppPage();
  }
}

class _MultiTouchAppPage extends State<MultiTouchAppPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;

  double _currentPage = 0.0;
  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: widget.position);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new LayoutBuilder(
          builder: (context, constraints) =>
          new NotificationListener(
            onNotification: (ScrollNotification note) {
              setState(() {
                _currentPage = _pageController.page;
              });
            },
            child: new PageView.custom(
              physics: const PageScrollPhysics(
                  parent: const BouncingScrollPhysics()),
              controller: _pageController,
              childrenDelegate: new SliverChildBuilderDelegate(
                    (context, index) =>
                new _SimplePage(
                  widget.imgUrls[index],
                  parallaxOffset: constraints.maxWidth /
                      2.0 *
                      (index - _currentPage),
                ),
                childCount: widget.imgUrls.length,
              ),
            ),
          )),
    );
  }
}

class _SimplePage extends StatelessWidget {
  _SimplePage(this.data, {Key key, this.parallaxOffset = 0.0})
      : super(key: key);

  final String data;
  final double parallaxOffset;

  double position_y;
  @override
  Widget build(BuildContext context) =>
      new GestureDetector(
        child: new Container(
          child: new Center(
              child: Hero(tag: data, child: new CachedNetworkImage(
              fit: BoxFit.fitWidth,
              imageUrl: Constant.baseUrl + data,
              ),)
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
          _showBottomItem(context, Constant.baseUrl + data);
        },
      );


  _showBottomItem(BuildContext context, String url) {
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
                      SaveFile().saveImage(url).then((onValue) {
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
