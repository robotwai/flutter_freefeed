import 'f_repository.dart';
import 'dart:async';
import 'package:flutter_app/model/feed_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
class FeedRepositoryImpl implements FeedRepository{
  @override
  Future<List<Micropost>> fetch(String token,int pageNum) {
    // TODO: implement fetch
      return _getData(token,pageNum);

  }

}

Future<List<Micropost>> _getData(String token,int pageNum) async {
  var httpClient = new HttpClient();
  var uri = new Uri.http(
      '127.0.0.1:3000', '/app/feed',
      {'token': token, 'page': '$pageNum'});



  List flModels;
  try {
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      flModels = jsonDecode(json)['data'];
      print(flModels);

    } else {
      //todo
    }
  } catch (exception) {
    //todo
  }

  return flModels.map((model) {
    return new Micropost.fromJson(model);
  }).toList();
}