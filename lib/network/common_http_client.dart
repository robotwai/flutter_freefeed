import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_app/widget/constant.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/sp_local.dart';
class FFHttpUtils {
  static final FFHttpUtils origin =  FFHttpUtils(new HttpClient());

  HttpClient httpClient;
  FFHttpUtils(this.httpClient);

  Future<List<Micropost>> getFeed(Map<String, String> options) async{
    var uri = new Uri.http(
        Constant.baseUrl, '/app/feed',
        options);
    List flModels=[];
    try {
      print(uri.toString());
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      int statusCode = response.statusCode;
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        String code = jsonDecode(json)['status'];
        print('code'+ code);
        if(int.parse(code)==Constant.HTTP_OK){
          print('codeok');
          flModels = jsonDecode(json)['data'];
        }else if(int.parse(code)==Constant.HTTP_TOKEN_ERROR){
          print('codeHTTP_TOKEN_ERROR');
          CommonSP.saveAccount('');
        }

      } else {
        //todo
        print('statusCode'+ '$statusCode');
      }
    } catch (exception) {
      //todo
      print(exception.toString());

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
