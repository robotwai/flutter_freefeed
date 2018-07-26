import 'dart:async';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/network/common_http_client.dart';
abstract class FeedRepository{
  Future<List<Micropost>> fetch(String token,int pageNum);
}