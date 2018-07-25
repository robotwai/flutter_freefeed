import 'dart:async';
import 'package:flutter_app/model/feed_model.dart';
abstract class FeedRepository{
  Future<List<Micropost>> fetch(String token,int pageNum);
}