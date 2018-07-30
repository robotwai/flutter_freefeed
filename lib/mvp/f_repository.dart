import 'dart:async';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/network/common_http_client.dart';

abstract class FeedRepository{
  void start(String token,int pageNum);
}

abstract class NetworkBoundResource<T>{
  void loadForDB(T t);
  void loadForNet(T t);
  void loadForEmpty();
}