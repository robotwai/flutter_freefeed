import 'f_repository.dart';
import 'dart:async';
import 'package:flutter_app/model/feed_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/widget/constant.dart';
import 'package:flutter_app/network/common_http_client.dart';
import 'package:flutter_app/db_helper.dart';
class FeedRepositoryImpl implements FeedRepository{

  NetworkBoundResource n;


  FeedRepositoryImpl(this.n);

  @override
  void start(String token, int pageNum) {
    loadForDB(pageNum).then((onValue){
      n.loadForDB(onValue);
    }).catchError((onError){
      n.loadForEmpty();
    });
    loadForNetWork(token,pageNum).then((onValue){
      n.loadForNet(onValue);
      MicropostProvider.origin.insertAll(onValue);
    }).catchError((onError){
      n.loadForEmpty();
    });
  }

  Future<List<Micropost>> loadForDB(int pageNum) {
    // TODO: implement fetch
    return MicropostProvider.origin.getList(pageNum);
  }

  Future<List<Micropost>> loadForNetWork(String token,int pageNum) {
    Map<String,String> op = new Map();
    op['token'] = token;
    op['page'] = '$pageNum';
    return FFHttpUtils.origin.getFeed(op);
  }
}

