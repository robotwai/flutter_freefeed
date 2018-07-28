import 'f_repository.dart';
import 'dart:async';
import 'package:flutter_app/model/feed_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:flutter_app/widget/constant.dart';
import 'package:flutter_app/network/common_http_client.dart';
class FeedRepositoryImpl implements FeedRepository{

  @override
  Future<List<Micropost>> fetch(String token,int pageNum) {
    // TODO: implement fetch
    Map<String,String> op = new Map();
    op['token'] = token;
    op['page'] = '$pageNum';
    FFHttpUtils.origin.getFeed(op);

  }


}
