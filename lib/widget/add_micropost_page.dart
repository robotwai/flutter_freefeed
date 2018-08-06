import 'package:flutter/material.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/widget/add_icon.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
      body: new SingleChildScrollView(
          child: new Column(
        children: <Widget>[
          _getEdit(),
          new Container(
            margin: const EdgeInsets.only(top: 30.0, left: 14.0, right: 14.0),
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: _buildGrid(),
          ),
          new Container(
            child: new Text('this the bottom'),
          )
        ],
      )),
    );
  }

  Widget _getTopIcon() {
    if (account == null || account.icon == null) {
      return new Image.asset("images/shutter.png",
        width: 36.0,
        height: 36.0,);
    } else {
      return new FadeInImage.assetNetwork(

        placeholder: "images/shutter.png",
        //预览图
        fit: BoxFit.fitWidth,
        image: Constant.baseUrl + account.icon,
        width: 36.0,
        height: 36.0,
      );
    }
  }
  Widget _getEdit() {
    return new Container(
      height: 100.0,
      padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 20.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      child: new TextField(
        maxLength: 140,
        onChanged: (text) {
          _onTextChange(text);
        },
        decoration: new InputDecoration(hintText: '写点什么...'),
        style: new TextStyle(color: Color(0xff000000), fontSize: 16.0),
        autofocus: true,
        maxLines: 8,
      ),
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
      var uri = Uri.parse(Constant.baseUrl + '/app/seedmicropost');
      var request = new http.MultipartRequest("POST", uri);
      request.fields['token'] = '0';
      request.fields['content'] = content;

      List<http.MultipartFile> f = await getFiles();
      int picNum = f.length;
      request.fields['picNum'] = '$picNum';
      request.files.addAll(f);
      request.send().then((response) {
        if (response.statusCode == 200) print("Uploaded!");
      });
    } catch (exception) {
      print(exception.toString());
    }
    print('send');
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
        child: Image.asset("images/add_icon.png"),
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

    getImage(index);
  }


  Future getImage(int index) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      print(image.path);
      images[index]=(image.path);
      if(images.length<9){
        images.add('0');
      }
    });
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
