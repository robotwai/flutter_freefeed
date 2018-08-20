import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/model/account_model.dart';
import 'dart:convert';
import 'dart:async';

class CommonSP{
  static saveAccount(Account a) async {
    String json;
    if (a != null) {
      json = jsonEncode(a);
    } else {
      json = '';
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("saveAccount" + json);
    prefs.setString('account', json);
  }

  static Future<Account> getAccount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json =prefs.getString('account');
    if(json==null||json.isEmpty){
      return null;
    }
    print("getAccount" + json);
    Map userMap = jsonDecode(json);
    Account user = new Account.fromJson(userMap);
    if (user.token == null || user.token.isEmpty) {
      return null;
    }
    return user;
  }

  static void saveDBPath(String json) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('micropost_db_path', json);
  }

  static Future<String> getDBPath() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json =prefs.getString('micropost_db_path');
    return json;
  }

  static void saveEmail(String json) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', json);
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = prefs.getString('email');
    return json;
  }
}