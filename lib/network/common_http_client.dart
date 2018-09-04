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
    var uri = Uri.parse(Constant.baseUrl + '/app/feed');
    List flModels=[];
    try {
      var request = new http.Request("GET", uri);
      request.bodyFields = options;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        flModels = jsonDecode(json)['data'];
      } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
        print('codeHTTP_TOKEN_ERROR');
        CommonSP.saveAccount(null);
      }
    }
    catch (exception) {
//      //todo
      print(exception.toString());
    }
    return flModels.map((model) {
      return new Micropost.fromJson(model);
    }).toList();

  }

  //点赞功能
  Future<Micropost> dot(Micropost item) async {
    Micropost mic;
    Account account = await CommonSP.getAccount();
    String token = account.token;
    String url = item.dotId != 0 ? '/app/dotDestroy' : '/app/dot';

    Map<String, String> op = new Map();
    op['token'] = token;
    op['micropost_id'] = item.dotId != 0 ? item.dotId.toString() : item.id
        .toString();
    var uri = Uri.parse(Constant.baseUrl + url);

    try {
      var request = new http.Request("POST", uri);
      request.bodyFields = op;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        String data = jsonDecode(json)['data'];
        Map userMap = jsonDecode(data);
        mic = new Micropost.fromJson(userMap);
      } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
        print('codeHTTP_TOKEN_ERROR');
        CommonSP.saveAccount(null);
      }

    } catch (exception) {
      //todo
      print(exception.toString());
    }
    return mic;
  }

  Future<Micropost> getMicropost(int id) async {
    Micropost mic;
    Account account = await CommonSP.getAccount();
    String token = account.token;
    String url = '/app/getMicropost';

    Map<String, String> op = new Map();
    op['token'] = token;
    op['id'] = '$id';
    var uri = Uri.parse(Constant.baseUrl + url);

    try {
      var request = new http.Request("GET", uri);
      request.bodyFields = op;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        String data = jsonDecode(json)['data'];
        Map userMap = jsonDecode(data);
        mic = new Micropost.fromJson(userMap);
      } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
        print('codeHTTP_TOKEN_ERROR');
        CommonSP.saveAccount(null);
      }

    } catch (exception) {
      //todo
      print(exception.toString());
    }
    return mic;
  }

  //登录
  Future<String> login(String email, String password) async {
    String res = '';
    var uri = Uri.parse(Constant.baseUrl + '/app/loggin');
    Map<String, String> op = new Map();
    op['email'] = '$email';
    op['password'] = '$password';
    try {
      var request = new http.Request("POST", uri);
      request.bodyFields = op;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        String data = jsonDecode(json)['data'];
        print('data' + data);
        Map userMap = jsonDecode(data);
        Account user = new Account.fromJson(userMap);
        await CommonSP.saveAccount(user);
        print(user.email);
        CommonSP.saveEmail(user.email);
        res = '0';
      } else {
        res = '网络异常';
      }
    } catch (exception) {
      //todo
      print(exception.toString());
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
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      Map jsonMap = jsonDecode(json);
      print(jsonMap['data']);
      if (int.parse(jsonMap['status']) != Constant.HTTP_OK) {
        res = '请检查网络';
      } else {
        res = '0';
      }
//      if (response.statusCode == 200) {
//        res = '0';
//      } else {
//        res = '请检查网络';
//      }
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
    var uri = Uri.parse(Constant.baseUrl + '/app/getCommit');
    List flModels = [];
    Map<String, String> op = new Map();
    op['id'] = '$id';
    op['page'] = '$pageNum';
    try {
      var request = new http.Request("GET", uri);
      request.bodyFields = op;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        flModels = jsonDecode(json)['data'];
      } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
        print('codeHTTP_TOKEN_ERROR');
        CommonSP.saveAccount(null);
      }
    }
    catch (exception) {
//      //todo
      print(exception.toString());
    }
    return flModels.map((model) {
      return new Commit.fromJson(model);
    }).toList();

  }

  //获取点赞列表
  Future<List<Dot>> getDots(int pageNum, int id) async {
    var uri = Uri.parse(Constant.baseUrl + '/app/getDots');
    List flModels = [];
    Map<String, String> op = new Map();
    op['id'] = '$id';
    op['page'] = '$pageNum';
    Account account = await CommonSP.getAccount();
    op['token'] = account.token;
    try {
      var request = new http.Request("GET", uri);
      request.bodyFields = op;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        flModels = jsonDecode(json)['data'];
      } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
        print('codeHTTP_TOKEN_ERROR');
        CommonSP.saveAccount(null);
      }
    }
    catch (exception) {
//      //todo
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
    User user;
    try {
      var uri = Uri.parse(Constant.baseUrl + '/app/getUser');
      var request = new http.Request("GET", uri);
      Account account = await CommonSP.getAccount();
      Map<String, String> op = new Map();
      op['user_id'] = '$id';
      op['token'] = account.token;

      request.bodyFields = op;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        String data = jsonDecode(json)['data'];
        Map userMap = jsonDecode(data);
        user = new User.fromJson(userMap);
      } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
        print('codeHTTP_TOKEN_ERROR');
        CommonSP.saveAccount(null);
      }
    } catch (exception) {
      print(exception.toString());
    }


    return user;
  }

  //获取用户推文列表
  Future<List<Micropost>> getMicropostList(int id, int pageNum) async {
    var uri = Uri.parse(Constant.baseUrl + '/app/getUserMicroposts');
    List flModels = [];
    try {
      Account account = await CommonSP.getAccount();
      Map<String, String> op = new Map();
      op['user_id'] = '$id';
      op['page'] = '$pageNum';
      op['token'] = account.token;
      var request = new http.Request("GET", uri);
      request.bodyFields = op;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        flModels = jsonDecode(json)['data'];
      } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
        print('codeHTTP_TOKEN_ERROR');
        CommonSP.saveAccount(null);
      }
    }
    catch (exception) {
//      //todo
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
    var uri = Uri.parse(Constant.baseUrl + '/app/get_follower_users');
    List flModels = [];
    try {
      var request = new http.Request("GET", uri);
      request.bodyFields = op;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        flModels = jsonDecode(json)['data'];
      } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
        print('codeHTTP_TOKEN_ERROR');
        CommonSP.saveAccount(null);
      }
    }
    catch (exception) {
//      //todo
      print(exception.toString());
    }
    return flModels.map((model) {
      return new User.fromJson(model);
    }).toList();
  }

  //更新用户信息
  Future<String> updateUser(String iconPath, String name, String sign_content,
      int sex) async {
    String res = '';
    try {
      var uri = Uri.parse(Constant.baseUrl + '/app/user_update');
      var request = new http.MultipartRequest("POST", uri);
      Account account = await CommonSP.getAccount();
      request.fields['token'] = account.token;
      if (sign_content != null) {
        request.fields['sign_content'] = sign_content;
      }
      if (name != null) {
        request.fields['name'] = name;
      }
      if (sex != null) {
        request.fields['sex'] = '$sex';
      }
      if (iconPath != null && iconPath != '') {
        http.MultipartFile icon = await http.MultipartFile
            .fromPath('icon', iconPath,
            contentType: MediaType.parse("multipart/form-data"));

        request.files.add(icon);
      }
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      Map jsonMap = jsonDecode(json);
      print(jsonMap['data']);
      if (int.parse(jsonMap['status']) != Constant.HTTP_OK) {
        res = '请检查网络';
      } else {
        Map userMap = jsonDecode(jsonMap['data']);
        Account user = new Account.fromJson(userMap);
        await CommonSP.saveAccount(user);

        print(user.email);
        CommonSP.saveEmail(user.email);
        res = '0';
      }
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

  //获取用户点赞推文列表
  Future<List<Micropost>> getDotMicropostList(int id, int pageNum) async {
    var uri = Uri.parse(Constant.baseUrl + '/app/getUserDotMicroposts');
    List flModels = [];
    try {
      Account account = await CommonSP.getAccount();
      Map<String, String> op = new Map();
      op['user_id'] = '$id';
      op['page'] = '$pageNum';
      op['token'] = account.token;
      var request = new http.Request("GET", uri);
      request.bodyFields = op;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        flModels = jsonDecode(json)['data'];
      } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
        print('codeHTTP_TOKEN_ERROR');
        CommonSP.saveAccount(null);
      }
    }
    catch (exception) {
//      //todo
      print(exception.toString());
    }
    return flModels.map((model) {
      return new Micropost.fromJson(model);
    }).toList();
  }

  //获取用户点赞推文列表
  Future<List<Micropost>> getFindMicropostList(int pageNum) async {
    var uri = Uri.parse(Constant.baseUrl + '/app/getFindMicroposts');
    List flModels = [];
    try {
      Account account = await CommonSP.getAccount();
      Map<String, String> op = new Map();
      op['page'] = '$pageNum';
      op['token'] = account.token;
      var request = new http.Request("GET", uri);
      request.bodyFields = op;
      print(uri.toString());
      http.StreamedResponse response = await request.send();
      String json = await response.stream.bytesToString();
      String code = jsonDecode(json)['status'];
      print('code' + code);
      if (int.parse(code) == Constant.HTTP_OK) {
        print('codeok');
        flModels = jsonDecode(json)['data'];
      } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
        print('codeHTTP_TOKEN_ERROR');
        CommonSP.saveAccount(null);
      }
    }
    catch (exception) {
//      //todo
      print(exception.toString());
    }
    return flModels.map((model) {
      return new Micropost.fromJson(model);
    }).toList();
  }

  //删除微博
  Future<String> micropost_destroy(int id) async {
    var uri = Uri.parse(Constant.baseUrl + '/app/micropost_destroy');
    print(uri.toString());
    var request = new http.MultipartRequest("POST", uri);
    Account account = await CommonSP.getAccount();
    request.fields['token'] = account.token;
    request.fields['id'] = '$id';
    String res = '';

    http.StreamedResponse response = await request.send();
    String json = await response.stream.bytesToString();
    String code = jsonDecode(json)['status'];
    print('code' + code);
    if (int.parse(code) == Constant.HTTP_OK) {
      print('codeok');
      res = '0';
    } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
      print('codeHTTP_TOKEN_ERROR');
      CommonSP.saveAccount(null);
    } else {
      res = '请检查网络';
    }
    return res;
  }

  //注销账号
  Future<String> account_destroy(String password) async {
    var uri = Uri.parse(Constant.baseUrl + '/app/account_destroy');
    print(uri.toString());
    var request = new http.MultipartRequest("POST", uri);
    Account account = await CommonSP.getAccount();
    request.fields['token'] = account.token;
    request.fields['password'] = password;
    String res = '';

    http.StreamedResponse response = await request.send();
    String json = await response.stream.bytesToString();
    String code = jsonDecode(json)['status'];
    print('code' + code);
    if (int.parse(code) == Constant.HTTP_OK) {
      print('codeok');
      res = '0';
    } else if (int.parse(code) == Constant.HTTP_TOKEN_ERROR) {
      print('codeHTTP_TOKEN_ERROR');
      CommonSP.saveAccount(null);
    } else {
      res = '请检查网络';
    }
    return res;
  }
}

