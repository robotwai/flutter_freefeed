import 'package:flutter/material.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/network/common_http_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_app/utils/toast_utils.dart';

class AddMicropostPage extends StatefulWidget {
  @override
  _AddMicropostPageState createState() {
    return new _AddMicropostPageState();
  }
}

class _AddMicropostPageState extends State<AddMicropostPage> {
  Account account;
  int sendColor = 0xFF9c9c9c;
  List<String> images = ['0'];
  String content;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    CommonSP.getAccount().then((onValue) {
      setState(() {
        account = onValue;
      });
    });
//    _tabController = new TabController(vsync: this, length: choices.length);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Container(
          child: new Center(
            child: new ClipOval(
              child: _getTopIcon(),
            ),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xFFFFFFFF),
        leading: new IconButton(
          tooltip: 'Previous choice',
          icon: const Icon(Icons.close),
          color: Color(0xFF000000),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.send),
            tooltip: 'Next choice',
            color: Color(sendColor),
            onPressed: () {
              _sendMicropost();
            },
          ),
        ],
      ),
        body: new Stack(
          children: <Widget>[
            new Container(
              child: new SingleChildScrollView(
                  child: new Column(
                    children: <Widget>[
                      _getEdit(),
                      new Container(
                        margin: const EdgeInsets.only(
                            top: 30.0, left: 14.0, right: 14.0),
                        height: MediaQuery
                            .of(context)
                            .size
                            .width,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: _buildGrid(),
                      ),
                    ],
                  )),
              color: Color(CLS.BACKGROUND),
            ),
            new Offstage(
              child: new Container(
                color: Color(CLS.HALF_BACKGROUND),
                child: new Center(
                  child: new CupertinoActivityIndicator(radius: 20.0),),
              ),
              offstage: !isLoading,
            )
          ],
        )
    );
  }

  Widget _getTopIcon() {
    if (account == null || account.icon == null) {
      return new Image.asset("images/shutter.png",
        width: 36.0,
        height: 36.0,);
    } else {
      return new CachedNetworkImage(

        //预览图
        fit: BoxFit.fitWidth,
        imageUrl: Constant.baseUrl + account.icon,
        width: 36.0,
        height: 36.0,
      );
    }
  }

  double position_y;
  Widget _getEdit() {
    return new GestureDetector(
      child: new Container(
        height: 150.0,
        color: Color(CLS.BACKGROUND),
        padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 20.0),
        margin: const EdgeInsets.only(bottom: 20.0),
        child: new TextField(
          maxLength: 140,
          onChanged: (text) {
            _onTextChange(text);
          },
          decoration: new InputDecoration(
              hintText: '写点什么...', border: InputBorder.none),
          style: new TextStyle(color: Color(0xff000000), fontSize: 16.0),
          autofocus: true,
          maxLines: 8,
        ),
      ),
      onVerticalDragDown: (de) {
        position_y = de.globalPosition.dy;
        print(position_y.toString());
      },
      onVerticalDragUpdate: (de) {
        if (de.globalPosition.dy - position_y > 40.0) {
          FocusScope.of(context).requestFocus(new FocusNode());
        }
      },

    );
  }

  Future<List<http.MultipartFile>> getFiles() async {
    List<http.MultipartFile> l = [];
    int i = 0;
    for (var x in images) {
      if (x != '0') {
        print(x);
        http.MultipartFile h = await http.MultipartFile.fromPath(
            'picture' + '$i',
            x,
            contentType: MediaType.parse("multipart/form-data"));
        l.add(h);
        i++;
      }
    }
    print(l);
    return l;
  }

  void _sendMicropost() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<http.MultipartFile> f = await getFiles();
      int picNum = f.length;
      FFHttpUtils.origin.sendMicropost(content, '$picNum', f)
          .then((onValue) {
        if (onValue != null) {
          if (onValue == '0') {
            ToastUtils.showSuccessToast('发送成功');
            Navigator.of(context).pop(1);
          } else {
            ToastUtils.showWarnToast('发送失败');
          }
        } else {
          ToastUtils.showWarnToast('发送失败');
        }
        setState(() {
          isLoading = false;
        });
      });
    } catch (exception) {
      print(exception.toString());
    }
  }


  Widget _buildGrid() {
    return new GridView.builder(
      gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150.0),

      itemBuilder: _buildRow,
      itemCount: images.length,

    );
  }

  Widget _buildRow(BuildContext context, int index) {
    final String path = images[index];
    if (path == '0') {
      return new GestureDetector(
        onTap: () {
          setState(() {
            _addImage(index);
          });
        },
        child: new Center(
          child: Image.asset("images/add_icon.png", width: 80.0, height: 80.0,),
        ),
      );
    } else {
      return new GestureDetector(
        onTap: () {
          setState(() {
            _addImage(index);
          });
        },
        child: Image.file(new File(path)),
      );
    }
  }


  _addImage(int index) {
    print('addimage' + '$index');
    FocusScope.of(context).requestFocus(new FocusNode());
//    getImage(index);

    _selectIcon(index);
  }


  _selectIcon(int index) {
    showModalBottomSheet<Null>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              height: 162.0,
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text(
                      '选择照片',
                      style: new TextStyle(
                          color: Color(CLS.TEXT_9), fontSize: 12.0),
                    ),
                    height: 40.0,
                    alignment: Alignment.center,
                    color: Color(0xffffffff),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                        '拍照',
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
                      getImage(1, index);
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
                        '从相册中选取照片',
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
                      getImage(2, index);
                    },
                  ),
                  new GestureDetector(
                    child: new Container(
                      child: new Text(
                        '录像',
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
                      getImage(1, index);
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
                        '从相册中选取录像',
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
                      getImage(2, index);
                    },
                  ),
                ],
              ));
        });
  }

  Future getImage(int type, int index) async {
    var image = await ImagePicker.pickImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery);

    if (image != null) {
      String newfileName;
      try {
        ImageProperties properties = await FlutterNativeImage
            .getImageProperties(image.path);
        print('pro== width' + properties.width.toString() + '+++++height' +
            properties.height.toString());
        int width = properties.width;
        int height = 0;
        if (width < 720) {
          height = properties.height;
        } else {
          height = (720 * (properties.height / width)).toInt();
          width = 720;
        }
        print('compressedFile== width' + width.toString() + '+++++height' +
            height.toString());
        File compressedFile = await FlutterNativeImage.compressImage(image.path,
            quality: 70, targetWidth: width, targetHeight: height);
        newfileName = compressedFile.path;
        print(compressedFile.path);
      } catch (exception) {
        print(exception.toString());
        newfileName = image.path;
      }

      setState(() {
        print(image.path);
        images[index] = (newfileName);
        if (images.length < 9 && index == images.length - 1) {
          images.add('0');
        }
      });
    }

  }

  Future getVideo(int type, int index) async {
    var video = await ImagePicker.pickVideo(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery);

    if (video != null) {
      setState(() {
        print(video.path);
        images[index] = (video.path);
        if (images.length < 9 && index == images.length - 1) {
          images.add('0');
        }
      });
    }
  }
  void _onTextChange(String s) {
    if (s != null && s.length > 0) {
      content = s;
      setState(() {
        sendColor = 0xff000000;
      });
    } else {
      setState(() {
        sendColor = 0xFF9c9c9c;
      });
    }
  }
}
