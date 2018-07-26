import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_app/widget/constant.dart';
import 'package:flutter_app/model/feed_model.dart';
class FFHttpUtils {
  static final FFHttpUtils origin =  FFHttpUtils(new HttpClient());

  HttpClient httpClient;
  FFHttpUtils(this.httpClient);

  Future<List<Micropost>> getFeed(Map<String, String> options) async{
    var uri = new Uri.http(
        Constant.baseUrl, '/app/feed',
        options);
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
}


abstract class Callback{
  void success(String response);
  void fail(String error);
}
