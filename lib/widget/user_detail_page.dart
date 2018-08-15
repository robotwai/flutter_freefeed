import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constant.dart';

class UserDetailPage extends StatefulWidget {
  int id;

  UserDetailPage(this.id);

  @override
  _UserDetailPageState createState() {
    return new _UserDetailPageState();
  }
}

class _UserDetailPageState extends State<UserDetailPage> {
  final List<String> _tabs = <String>[
    '推文',
    '回复',
    '点赞',
  ];

  @override
  Widget build(BuildContext context) {
    final appTitle = 'NestedScrollView';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        body: new Center(
          child: new DefaultTabController(
            //选项卡数量
            length: _tabs.length,
            child: new NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverOverlapAbsorber(
                    handle: NestedScrollView
                        .sliverOverlapAbsorberHandleFor(context),
                    child: new SliverAppBar(
                      //appbar标题
                      title: new Container(
                        child: new Text('124556'),
                        color: Color(CLS.BACKGROUND),
                      ),
                      leading: new Text('124556'),
                      //列表在滚动的时候appbar是否一直保持可见
                      pinned: true,
                      //展开的最大高度
                      expandedHeight: 300.0,
                      flexibleSpace: const FlexibleSpaceBar(
                        //背景,final Widget background;
                        //我们要使用的Image对象必须是const声明的常量对象,对象不可变
                        background: const Image(
                          colorBlendMode: BlendMode.multiply,
                          color: Colors.black38,
                          image: const AssetImage("images/top.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),

                      //强制appbar下面有阴影
                      forceElevated: true,

                      //显示在appbar下方,通常是TabBar,且小部件必须实现[PreferredSizeWidget]
                      //才能在bottom中使用!!!!
                      bottom: new TabBar(
                        isScrollable: false,
                        indicatorWeight: 3.0,
                        //Tab选项卡小部件
                        tabs: _tabs
                            .map((String name) => new Tab(text: name))
                            .toList(),
                      ),
                    ),
                  ),
                ];
              },
              body: new TabBarView(

                ///下面是选项卡视图的内容列表,自己任意发挥即可
                children: _tabs.map((String name) {
                  return new SafeArea(
                    top: false,
                    bottom: false,
                    child: new Builder(

                      ///这个Builder需要提供一个BuildContext，
                      ///它“在”NestedScrollView中，
                      ///以便SliverOverlapAbsorberHandleFor()可以找到NestedScrollView。
                      builder: (BuildContext context) {
                        return new CustomScrollView(

                          ///”controller”和“primary”不设置，以便NestedScrollView可以控制该内部滚动视图。
                          ///如果设置了“controller”属性，则此滚动视图将不会与NestedScrollView相关联。
                          ///PageStorageKey应为此ScrollView所独有；
                          ///它允许列表在选项卡视图不在屏幕上时记住其滚动位置。
                          key: new PageStorageKey<String>(name),
                          slivers: <Widget>[
                            new SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                            ),
                            new SliverPadding(
                              padding: const EdgeInsets.all(8.0),
                              //创建一个有固定item的列表
                              sliver: new SliverFixedExtentList(
                                //item高度48像素
                                itemExtent: 48.0,
                                delegate: new SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return new ListTile(
                                      title: new Text('Item $index'),
                                    );
                                  },
                                  childCount: 30,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
