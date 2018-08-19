import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_app/utils/constant.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_app/model/commit_model.dart';
import 'package:flutter_app/model/dot_model.dart';
import 'package:flutter_app/model/user_model.dart';
class FFHttpUtils {
  static final FFHttpUtils origin =  FFHttpUtils(new HttpClient());

  HttpClient httpClient;
  FFHttpUtils(this.httpClient);

  //获取首页Feed列表
  Future<List<Micropost>> getFeed(Map<String, String> options) async{
    var uri = new Uri.http(
        Constant.baseUrlNoHttp, '/app/feed',
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
          CommonSP.saveAccount(null);
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

  //点赞功能
  Future<Micropost> dot(Micropost item) async {
    Micropost data;
    Account account = await CommonSP.getAccount();
    String token = account.token;
    String url = item.dotId != 0 ? '/app/dotDestroy' : '/app/dot';
    var uri = new Uri.http(Constant.baseUrlNoHttp, url,
        {
          'token': '$token',
          'micropost_id': item.dotId != 0 ? item.dotId.toString() : item.id
              .toString()
        });
    try {
      print(uri.toString());
      var request = await httpClient.postUrl(uri);
      var response = await request.close();
      int statusCode = response.statusCode;
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        String code = jsonDecode(json)['status'];
        print('code' + code);
        if (int.parse(code) == Constant.HTTP_OK) {
          print('codeok');
          Map jsonMap = JSON.decode(json);
          Map userMap = JSON.decode(jsonMap['data']);
          data = new Micropost.fromJson(userMap);
          print(jsonDecode(json)['data']);
//          data = new Micropost.fromJson(jsonDecode(json)['data']);
        } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
          print('codeHTTP_TOKEN_ERROR');
          CommonSP.saveAccount(null);
        }
      } else {
        //todo
        print('statusCode' + '$statusCode');
      }
    } catch (exception) {
      //todo
      print(exception.toString());
    }
    return data;
  }

  //登录
  Future<String> login(String email, String password) async {
    var uri = new Uri.http(Constant.baseUrlNoHttp, '/app/loggin',
        {'email': '$email', 'password': '$password'});
    var request = await httpClient.postUrl(uri);
    var response = await request.close();
    String res = '';
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      print(json);
      Map jsonMap = JSON.decode(json);
      print(jsonMap['data']);
      if (int.parse(jsonMap['status']) != Constant.HTTP_OK) {
        res = '账号密码错误';
      } else {
        Map userMap = JSON.decode(jsonMap['data']);
        Account user = new Account.fromJson(userMap);
        await CommonSP.saveAccount(user);

        print(user.email);
        CommonSP.saveEmail(user.email);
        res = '0';
      }
    } else {
      res = '网络异常';
    }
    return res;
  }

  //注册
  Future<String> register(String name, String email, String password,
      String iconPath) async {
    String res = '';
    try {
      var uri = Uri.parse(Constant.baseUrl + '/app/register');
      var request = new http.MultipartRequest("POST", uri);
      request.fields['email'] = email;
      request.fields['name'] = name;
      request.fields['password'] = password;
      request.fields['password_confirmation'] = password;
      if (iconPath != null && iconPath != '') {
        http.MultipartFile icon = await http.MultipartFile
            .fromPath('icon', iconPath,
            contentType: MediaType.parse("multipart/form-data"));

        request.files.add(icon);
      }
      http.BaseResponse response = await request.send();
      if (response.statusCode == 200) {
        res = '0';
      } else {
        res = '请检查网络';
      }
    } catch (exception) {
      print(exception.toString());
    }
    return res;
  }

  //发送微博
  Future<String> sendMicropost(String content, String picNum,
      List<http.MultipartFile> f) async {
    String res = '';
    var uri = Uri.parse(Constant.baseUrl + '/app/seedmicropost');
    var request = new http.MultipartRequest("POST", uri);
    Account account = await CommonSP.getAccount();
    request.fields['token'] = account.token;
    request.fields['content'] = content;

    int picNum = f.length;
    request.fields['picNum'] = '$picNum';
    if (f != null) {
      request.files.addAll(f);
    }
    http.BaseResponse response = await request.send();
    if (response.statusCode == 200) {
      res = '0';
    } else {
      res = '请检查网络';
    }
    return res;
  }

  //获取评论列表
  Future<List<Commit>> getComment(int pageNum, int id) async {
    Map<String, String> op = new Map();
    op['id'] = '$id';
    op['page'] = '$pageNum';
    var uri = new Uri.http(
        Constant.baseUrlNoHttp, '/app/getCommit',
        op);
    List flModels = [];
    try {
      print(uri.toString());
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      int statusCode = response.statusCode;
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        String code = jsonDecode(json)['status'];
        print('code' + code);
        if (int.parse(code) == Constant.HTTP_OK) {
          print('codeok');
          flModels = jsonDecode(json)['data'];
        } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
          print('codeHTTP_TOKEN_ERROR');
          CommonSP.saveAccount(null);
        }
      } else {
        //todo
        print('statusCode' + '$statusCode');
      }
    } catch (exception) {
      //todo
      print(exception.toString());
    }
    return flModels.map((model) {
      return new Commit.fromJson(model);
    }).toList();
  }

  //获取点赞列表
  Future<List<Dot>> getDots(int pageNum, int id) async {
    Map<String, String> op = new Map();
    op['id'] = '$id';
    op['page'] = '$pageNum';
    var uri = new Uri.http(
        Constant.baseUrlNoHttp, '/app/getDots',
        op);
    List flModels = [];
    try {
      print(uri.toString());
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      int statusCode = response.statusCode;
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        String code = jsonDecode(json)['status'];
        print('code' + code);
        if (int.parse(code) == Constant.HTTP_OK) {
          print('codeok');
          flModels = jsonDecode(json)['data'];
        } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
          print('codeHTTP_TOKEN_ERROR');
          CommonSP.saveAccount(null);
        }
      } else {
        //todo
        print('statusCode' + '$statusCode');
      }
    } catch (exception) {
      //todo
      print(exception.toString());
    }
    return flModels.map((model) {
      return new Dot.fromJson(model);
    }).toList();
  }

  //发送评论
  Future<String> sendCommit(int micropostId, String content) async {
    String res = '';
    var uri = Uri.parse(Constant.baseUrl + '/app/seedcommit');
    var request = new http.MultipartRequest("POST", uri);
    Account account = await CommonSP.getAccount();
    request.fields['token'] = account.token;
    request.fields['comment'] = content;
    request.fields['micropost_id'] = '$micropostId';

    http.BaseResponse response = await request.send();
    if (response.statusCode == 200) {
      res = '0';
    } else {
      res = '请检查网络';
    }
    return res;
  }

  //获取用户信息
  Future<User> getUser(int id) async {
    Account account = await CommonSP.getAccount();
    var uri = new Uri.http(Constant.baseUrlNoHttp, '/app/getUser',
        {'user_id': '$id', 'token': account.token});
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    User res = null;
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      print(uri.toString());
      Map jsonMap = JSON.decode(json);
      print(jsonMap['data']);
      if (int.parse(jsonMap['status']) != Constant.HTTP_OK) {
        res = null;
      } else {
        Map userMap = JSON.decode(jsonMap['data']);
        User user = new User.fromJson(userMap);

        print(user.email);

        res = user;
      }
    } else {
      res = null;
    }
    return res;
  }

  //获取用户推文列表
  Future<List<Micropost>> getMicropostList(int id, int pageNum) async {
    Map<String, String> op = new Map();
    op['user_id'] = '$id';
    op['page'] = '$pageNum';
    Account account = await CommonSP.getAccount();
    op['token'] = account.token;
    var uri = new Uri.http(
        Constant.baseUrlNoHttp, '/app/getUserMicroposts',
        op);
    List flModels = [];
    try {
      print(uri.toString());
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      int statusCode = response.statusCode;
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        String code = jsonDecode(json)['status'];
        print('code' + code);
        if (int.parse(code) == Constant.HTTP_OK) {
          print('codeok');
          flModels = jsonDecode(json)['data'];
        } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
          print('codeHTTP_TOKEN_ERROR');
          CommonSP.saveAccount(null);
        }
      } else {
        //todo
        print('statusCode' + '$statusCode');
      }
    } catch (exception) {
      //todo
      print(exception.toString());
    }
    return flModels.map((model) {
      return new Micropost.fromJson(model);
    }).toList();
  }

  //添加关注关系
  Future<String> follow(int id, int type) async {
    String res = '';
    String ul = '';
    if (type == 1) {
      ul = '/app/follow';
    } else {
      ul = '/app/unfollow';
    }
    var uri = Uri.parse(Constant.baseUrl + ul);
    print(uri.toString());
    var request = new http.MultipartRequest("POST", uri);
    Account account = await CommonSP.getAccount();
    request.fields['token'] = account.token;
    request.fields['id'] = '$id';


    http.BaseResponse response = await request.send();
    if (response.statusCode == 200) {
      res = '0';
    } else {
      res = '请检查网络';
    }
    return res;
  }

  //获取用户关注/粉丝列表
  Future<List<User>> getUserFollower(int id, int pageNum, int type) async {
    Map<String, String> op = new Map();
    op['id'] = '$id';
    op['page'] = '$pageNum';
    Account account = await CommonSP.getAccount();
    op['token'] = account.token;
    op['type'] = '$type';
    var uri = new Uri.http(
        Constant.baseUrlNoHttp, '/app/get_follower_users',
        op);
    List flModels = [];
    try {
      print(uri.toString());
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      int statusCode = response.statusCode;
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        String code = jsonDecode(json)['status'];
        print('code' + code);
        if (int.parse(code) == Constant.HTTP_OK) {
          print('codeok');
          flModels = jsonDecode(json)['data'];
        } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
          print('codeHTTP_TOKEN_ERROR');
          CommonSP.saveAccount(null);
        }
      } else {
        //todo
        print('statusCode' + '$statusCode');
      }
    } catch (exception) {
      //todo
      print(exception.toString());
    }
    return flModels.map((model) {
      return new User.fromJson(model);
    }).toList();
  }

  //更新用户信息
  Future<Account> updateUser(String iconPath, String name, String sign_content,
      int sex) async {
    String res = '';
    try {
      var uri = Uri.parse(Constant.baseUrl + '/app/user_update');
      var request = new http.MultipartRequest("POST", uri);
      request.fields['sign_content'] = sign_content;
      request.fields['name'] = name;
      request.fields['sex'] = '$sex';
      if (iconPath != null && iconPath != '') {
        http.MultipartFile icon = await http.MultipartFile
            .fromPath('icon', iconPath,
            contentType: MediaType.parse("multipart/form-data"));

        request.files.add(icon);
      }
      http.BaseResponse response = await request.send();
      if (response.statusCode == 200) {
        res = '0';
      } else {
        res = '请检查网络';
      }
    } catch (exception) {
      print(exception.toString());
    }
    return res;
  }
}

