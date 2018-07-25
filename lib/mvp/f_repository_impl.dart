import 'f_repository.dart';
import 'dart:async';
import 'package:flutter_app/model/feed_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
class FeedRepositoryImpl implements FeedRepository{
  @override
  Future<List<Micropost>> fetch(int pageNum) {
    // TODO: implement fetch


      return _getData(pageNum);

  }

}

Future<List<Micropost>> _getData(int pageNum) async {
  var httpClient = new HttpClient();
  CommonSP.getAccount().then((onValue){

  }
  );
  var uri = new Uri.http(
      '127.0.0.1:3000', '/app/loggin',
      {'email': '123', 'password': '111'});



  List flModels;
  try {
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      flModels = jsonDecode(json)['results'];
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