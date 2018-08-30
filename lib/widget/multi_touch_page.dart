import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  @override
  Widget build(BuildContext context) =>
      new GestureDetector(
        child: new Container(
          child: new Center(
            child: new CachedNetworkImage(
              fit: BoxFit.fitWidth,
              imageUrl: Constant.baseUrl + data,
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      );
}
